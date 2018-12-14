defmodule PhoenixMemes.MemeService do
  @moduledoc """
  MemeService is a module for fetching random memes using the 9gag/random page.
  """

  @doc """
  Fetches memes recursively by the count
  returns list of memes
  """
  def fetchRandomMemes(count, list \\ []) do
    if length(list) <= count do
      IO.puts("#{inspect(length(list))}")
      result = fetchRandomMeme()

      list =
        if result.status == :success do
          list ++ [result.data]
        end

      fetchRandomMemes(count, list)
    else
      list
    end
  end

  @doc """
  Fetches a random meme
  returns meme
  """
  def fetchRandomMeme do
    response = HTTPotion.get("https://9gag.com/random", follow_redirects: true)
    parse_tags(response.body)
    if HTTPotion.Response.success?(response) do
      id = parse_id(response.body)
      %{
        status: :success,
        data: %{
          id: id,
          title: parse_title(response.body),
          pageUrl: parse_pageUrl(response.body),
          imageUrl: parse_imgUrl(response.body),
          videoUrl: getVideoUrlIfExists(id),
          tags: parse_tags(response.body)
        }
      }
    else
      %{status: :failed, data: response}
    end
  end

  defp parse_page_data(html) do
    testtt = Floki.parse(html)
    html 
    |> Floki.find("script:fl-contains('GAG.App.loadConfigs')")
    |> hd
  end

  defp parse_tags(html) do
    testtt = html 
    |> Floki.find("script:fl-contains('\n    GAG.App.loadConfigs(')")

    Path.expand('./text.txt') |> Path.absname |> File.write(inspect(testtt), [:write])
    # IO.puts(tags)
  end

  defp parse_id(html) do
    pageUrl = parse_pageUrl(html)
    String.replace(pageUrl, "http://9gag.com/gag/", "")
  end

  defp parse_title(html) do
    html
    |> Floki.find("meta")
    |> Floki.find("[property='og:title']")
    |> hd
    |> Floki.attribute("content")
    |> hd
  end

  defp parse_pageUrl(html) do
    html
    |> Floki.find("meta")
    |> Floki.find("[property='og:url']")
    |> hd
    |> Floki.attribute("content")
    |> hd
  end

  defp parse_imgUrl(html) do
    html
    |> Floki.find("meta")
    |> Floki.find("[property='og:image']")
    |> hd
    |> Floki.attribute("content")
    |> hd
  end

  defp getVideoUrlIfExists(memeId) do
    newlink = "http://img-9gag-fun.9cache.com/photo/" <> memeId <> "_460sv.mp4"
    response = HTTPotion.head(newlink, follow_redirects: false)
    if response.status_code == 200 do
        newlink
    else
        nil
    end
  end
end