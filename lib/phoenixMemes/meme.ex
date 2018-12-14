defmodule PhoenixMemes.Meme do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key{:id, :string, []}
  schema "memes" do
    field :imageUrl, :string
    field :pageUrl, :string
    field :title, :string
    field :videoUrl, :string

    timestamps()
  end

  @doc false
  def changeset(meme, attrs) do
    meme
    |> cast(attrs, [:imageUrl, :pageUrl, :title, :videoUrl])
    |> validate_required([:imageUrl, :pageUrl, :title, :videoUrl])
  end
end
