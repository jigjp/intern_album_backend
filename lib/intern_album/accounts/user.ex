defmodule InternAlbum.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :icon_url, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :icon_url])
    |> validate_required([:name, :icon_url])
  end
end
