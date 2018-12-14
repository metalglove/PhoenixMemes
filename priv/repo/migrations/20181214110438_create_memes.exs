defmodule PhoenixMemes.Repo.Migrations.CreateMemes do
  use Ecto.Migration

  def change do
    create table(:memes, primary_key: false) do
      add(:imageUrl, :string)
      add(:pageUrl, :string)
      add(:title, :string)
      add(:videoUrl, :string)
      add(:id, :string, primary_key: true)

      timestamps()
    end

    create table(:tags) do
      add(:tag, :string, unique: true)

      timestamps()
    end

    create(unique_index(:tags, [:tag], name: :unique_tag))
  end
end
