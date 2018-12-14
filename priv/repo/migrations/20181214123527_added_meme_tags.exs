defmodule PhoenixMemes.Repo.Migrations.AddedMemeTags do
  use Ecto.Migration

  def change do
    create table(:memeTags) do
      add(:memeId, references(:memes, name: :id, type: :string, on_delete: :delete_all))
      add(:tagId, references(:tags, on_delete: :delete_all))

      timestamps()
    end
  end
end
