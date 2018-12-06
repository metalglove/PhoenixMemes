defmodule PhoenixMemes.Meme do
  use Ecto.Schema
  import Ecto.Changeset


  schema "memes" do
    field :imageUrl, :string
    field :memeId, :string
    field :pageUrl, :string
    field :title, :string
    field :videoUrl, :string

    timestamps()
  end

  @doc false
  def changeset(meme, attrs) do
    meme
    |> cast(attrs, [:memeId, :title, :imageUrl, :pageUrl, :videoUrl])
    |> validate_required([:memeId, :title, :imageUrl, :pageUrl, :videoUrl])
  end
end
