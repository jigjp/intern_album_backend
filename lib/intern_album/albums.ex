defmodule InternAlbum.Albums do
  @moduledoc """
  The Albums context.
  """

  import Ecto.Query, warn: false
  alias InternAlbum.Repo

  alias InternAlbum.Albums.Picture

  @doc """
  Returns the list of pictures.

  ## Examples

      iex> list_pictures()
      [%Picture{}, ...]

  """
  def list_pictures(folder) do
    query =
      from p in Picture,
      where: p.folder == ^folder
    Repo.all(query)
  end

  @doc """
  Gets a all folders
  """
  def list_folders() do
    query =
      from p in Picture,
      distinct: true,
      select: p.folder

    Repo.all(query)
  end

  @doc """
  Gets a single picture.

  Raises `Ecto.NoResultsError` if the Picture does not exist.

  ## Examples

      iex> get_picture!(123)
      %Picture{}

      iex> get_picture!(456)
      ** (Ecto.NoResultsError)

  """
  def get_picture!(id), do: Repo.get!(Picture, id)

  @doc """
  Creates a picture and File Save

  ## Examples

      iex> create_picture(%{field: value})
      {:ok, %Picture{}}

      iex> create_picture(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_picture(attrs \\ %{}) do
    with {:ok, upload} <- map_fetch_atom_or_string(attrs, :image),
      filename <- "#{UUID.uuid4()}#{Path.extname(upload.filename)}",
      :ok <- File.cp(upload.path, "media/#{filename}") do

      # 回転されている画像を修正する
      Mogrify.open("media/#{filename}")
      |> Mogrify.auto_orient()
      |> IO.inspect
      |> Mogrify.save(in_place: true)

      new_attrs = Map.put(attrs, "url", "/media/#{filename}")

      %Picture{}
      |> Picture.changeset(new_attrs)
      |> Repo.insert()
    end

  end

  def create_pictures(attrs) do
    {:ok, folder} = attrs |> map_fetch_atom_or_string(:folder)
    attrs
    |> Map.drop(["folder", :folder])
    |> Map.to_list
    |> Enum.map(fn {_, image} ->
      create_picture(%{"folder" => folder, "image" => image})
    end)
  end

  defp map_fetch_atom_or_string(map, key) do
    case Map.get(map, key) || Map.get(map, Atom.to_string(key)) do
      nil -> {:error, "#{key} not found"}
      val -> {:ok, val}
    end
  end

  @doc """
  Updates a picture.

  ## Examples

      iex> update_picture(picture, %{field: new_value})
      {:ok, %Picture{}}

      iex> update_picture(picture, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_picture(%Picture{} = picture, attrs) do
    picture
    |> Picture.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Picture.

  ## Examples

      iex> delete_picture(picture)
      {:ok, %Picture{}}

      iex> delete_picture(picture)
      {:error, %Ecto.Changeset{}}

  """
  def delete_picture(%Picture{} = picture) do
    Repo.delete(picture)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking picture changes.

  ## Examples

      iex> change_picture(picture)
      %Ecto.Changeset{source: %Picture{}}

  """
  def change_picture(%Picture{} = picture) do
    Picture.changeset(picture, %{})
  end
end
