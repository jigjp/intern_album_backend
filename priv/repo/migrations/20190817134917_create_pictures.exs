defmodule InternAlbum.Repo.Migrations.CreatePictures do
  use Ecto.Migration

  def change do
    create table(:pictures) do
      add :folder, :string
      add :url, :string

      timestamps()
    end

  end
end
