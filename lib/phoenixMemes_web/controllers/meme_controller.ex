defmodule PhoenixMemesWeb.MemeController do
  alias PhoenixMemes.{Repo, Meme, MemeService}
  use PhoenixMemesWeb, :controller
  import Ecto.Query

  @doc """
  Fetches a random meme, inserts it into the repo and displays it.
  """
  def meme(conn, _params) do
    fetchedMeme = MemeService.fetchRandomMeme()
    
    IO.inspect(fetchedMeme.memeData)
    # Repo.insert_all(%{ tag: memeData.data.tags })

    meme = case Repo.insert(fetchedMeme.memeData.meme)
      do 
        {:ok, meme} -> 
          IO.puts("success") 
          meme
        {:error, changeset} -> 
          IO.puts("failed")
          IO.inspect(changeset)
          Meme |> last |> Repo.one
      end
      
    render(conn, "meme.html", meme: meme)
  end

  @doc """
  Fetches all memes in the repo and displays them.
  """
  def memes(conn, _params) do
    render(conn, "memes.html", memes: Meme |> Repo.all)
  end

  @doc """
  Fetches all memes in the repo and displays them.
  """
  def editMemes(conn, _params) do
    render(conn, "editMemes.html", memes: Meme |> Repo.all)
  end
end
