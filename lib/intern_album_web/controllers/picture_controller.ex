defmodule InternAlbumWeb.PictureController do
  use InternAlbumWeb, :controller

  alias InternAlbum.Albums
  alias InternAlbum.Albums.Picture

  action_fallback InternAlbumWeb.FallbackController

  def index(conn, %{"folder" => folder}) do
    pictures = Albums.list_pictures(folder)
    render(conn, "index.json", pictures: pictures)
  end

  def create(conn, picture_params) do
    IO.inspect picture_params
    with res <- Albums.create_pictures(picture_params) do
      IO.inspect res

      conn
      |> put_status(:created)
      |> render("success.json", %{})
    end
  end

  def show(conn, %{"id" => id}) do
    picture = Albums.get_picture!(id)
    render(conn, "show.json", picture: picture)
  end

  def update(conn, %{"id" => id, "picture" => picture_params}) do
    picture = Albums.get_picture!(id)

    with {:ok, %Picture{} = picture} <- Albums.update_picture(picture, picture_params) do
      render(conn, "show.json", picture: picture)
    end
  end

  def delete(conn, %{"id" => id}) do
    picture = Albums.get_picture!(id)

    with {:ok, %Picture{}} <- Albums.delete_picture(picture) do
      send_resp(conn, :no_content, "")
    end
  end
end
