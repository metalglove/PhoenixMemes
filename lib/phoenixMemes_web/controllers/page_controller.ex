defmodule PhoenixMemesWeb.PageController do
  use PhoenixMemesWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
