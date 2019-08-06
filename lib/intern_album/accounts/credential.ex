defmodule InternAlbum.Accounts.Credential do
  use Ecto.Schema
  import Ecto.Changeset

  alias InternAlbum.Accounts.User

  schema "credentials" do
    field :login_id, :string
    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(credential, attrs) do
    credential
    |> cast(attrs, [:login_id])
    |> validate_required([:login_id])
    |> unique_constraint(:login_id)
  end
end
