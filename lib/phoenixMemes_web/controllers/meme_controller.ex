defmodule PhoenixMemesWeb.MemeController do
  alias PhoenixMemes.{Repo, Meme, MemeService}
  use PhoenixMemesWeb, :controller
  import Ecto.Query

@doc """
  Fetches a random meme, inserts it into the repo and displays it.
  """
  def meme(conn, _params) do
    memeData = MemeService.fetchRandomMeme()
    render(conn, "meme.html", meme: 
    case Repo.insert(%Meme{
      memeId: memeData.data.memeId, 
      title: memeData.data.title, 
      imageUrl: memeData.data.imageUrl, 
      pageUrl: memeData.data.pageUrl, 
      videoUrl: memeData.data.videoUrl })
      do 
        {:ok, meme} -> 
          IO.puts("success") 
          meme
        {:error, changeset} -> 
          IO.puts("failed")
          IO.inspect(changeset)
          Meme |> last |> Repo.one
      end)
  end

@doc """
  Fetches all memes in the repo and displays them.
  """
  def memes(conn, _params) do
    render(conn, "memes.html", memes: Meme |> Repo.all)
  end
end
