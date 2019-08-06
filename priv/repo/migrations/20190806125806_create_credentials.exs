defmodule InternAlbum.Repo.Migrations.CreateCredentials do
  use Ecto.Migration

  def change do
    create table(:credentials) do
      add :login_id, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create unique_index(:credentials, [:login_id])
    create index(:credentials, [:user_id])
  end
end
