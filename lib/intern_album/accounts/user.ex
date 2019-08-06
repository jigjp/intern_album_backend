defmodule InternAlbum.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias InternAlbum.Accounts.Credential

  schema "users" do
    field :icon_url, :string
    field :name, :string
    has_one :credential, Credential

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :icon_url])
    |> validate_required([:name, :icon_url])
  end
end
