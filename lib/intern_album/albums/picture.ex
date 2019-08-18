defmodule InternAlbum.Albums.Picture do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pictures" do
    field :folder, :string
    field :url, :string

    timestamps()
  end

  @doc false
  def changeset(picture, attrs) do
    picture
    |> cast(attrs, [:folder, :url])
    |> validate_required([:folder, :url])
  end
end
