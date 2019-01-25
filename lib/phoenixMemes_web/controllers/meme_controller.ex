defmodule PhoenixMemesWeb.MemeController do
  alias PhoenixMemes.{Repo, Meme, MemeService}
  use PhoenixMemesWeb, :controller
  import Ecto.Query

  @doc """
  Fetches a random meme, inserts it into the repo and displays it.
  """
  def meme(conn, _params) do
    fetchedMeme = MemeService.fetchRandomMeme()
    
    # IO.inspect(fetchedMeme.memeData)
    hasTags = length(fetchedMeme.memeData.tags) >= 1
    ids = if hasTags do
      tags = for %{"key" => key, "url" => url} <- fetchedMeme.memeData.tags, do: [{:tag, key}], into: []
      # IO.inspect(tags)
      {count, ids} = Repo.insert_all("tags", tags, returning: [:id])
      # IO.inspect(ids)
      ids
    end

    meme = case Repo.insert(fetchedMeme.memeData.meme)
      do 
        {:ok, meme} -> 
          IO.puts(meme.id) 
          if hasTags do
            memeTags = for %{id: id} <- ids, do: [{:memeId, meme.id}, {:tagId, id}], into: []
            # IO.inspect(memeTags)
            Repo.insert_all("memeTags", memeTags)
          end
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
