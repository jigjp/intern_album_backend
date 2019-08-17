defmodule InternAlbumWeb.PictureController do
  use InternAlbumWeb, :controller

  alias InternAlbum.Albums
  alias InternAlbum.Albums.Picture

  action_fallback InternAlbumWeb.FallbackController

  def index(conn, _params) do
    pictures = Albums.list_pictures()
    render(conn, "index.json", pictures: pictures)
  end

  def create(conn, %{"picture" => picture_params}) do
    with {:ok, %Picture{} = picture} <- Albums.create_picture(picture_params) do

      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.picture_path(conn, :show, picture))
      |> render("show.json", picture: picture)
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
