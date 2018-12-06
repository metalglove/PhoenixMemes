defmodule PhoenixMemes.Repo.Migrations.CreateMemes do
  use Ecto.Migration

  def change do
    create table(:memes) do
      add :memeId, :string
      add :title, :string
      add :imageUrl, :string
      add :pageUrl, :string
      add :videoUrl, :string

      timestamps()
    end

  end
end
