defmodule InternAlbum.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :icon_url, :string

      timestamps()
    end
  end
end
