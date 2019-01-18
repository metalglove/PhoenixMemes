defmodule PhoenixMemes.MemeService do
  alias PhoenixMemes.Meme
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

    if HTTPotion.Response.success?(response) do
      post = parse_post(response.body)
      memes = post["nextPosts"] |> Enum.map(fn memee -> 
      %{
        meme: %Meme{
        id: memee["id"], 
        title: memee["title"], 
        pageUrl: memee["url"], 
        imageUrl: memee["images"]["image460"]["url"],
        videoUrl: memee["images"]["image460sv"]["url"]
        },
        tags: memee["tags"]
      } 
      end)

      %{
        status: :success,
        memeData: %{
          meme: %Meme{
          id: post["post"]["id"],
          title: post["post"]["title"],
          pageUrl: post["post"]["url"],
          imageUrl: post["post"]["images"]["image460"]["url"],
          videoUrl: post["post"]["images"]["image460sv"]["url"]
          },
          tags: post["post"]["tags"]
        }, 
        nextMemes: memes
      }
    else
      %{status: :failed, data: response}
    end
  end

  defp parse_post(html) do
    post = html 
    |> Floki.find("script:fl-contains('\n    GAG.App.loadConfigs(')") 
    |> hd 
    |> Floki.text(js: true)
    |> String.replace("\n    GAG.App.loadConfigs(", "")
    |> String.split(").loadAsynScripts([")
    |> hd
    |> Jason.decode!
    # Path.expand('./text.txt') |> Path.absname |> File.write(post, [:write])

    post["data"]
  end
end