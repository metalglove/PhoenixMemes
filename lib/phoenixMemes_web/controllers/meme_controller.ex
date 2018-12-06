defmodule PhoenixMemesWeb.MemeController do
  alias PhoenixMemes.{Repo, Meme}
  use PhoenixMemesWeb, :controller
  import Ecto.Query

  def meme(conn, _params) do
    render conn, "meme.html",
    memer: Meme |> Repo.one # first if empty and last if |> last
  end

  def memes(conn, _params) do
    render conn, "memes.html",
    memes: Meme |> Repo.all
  end
end
