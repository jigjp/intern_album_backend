defmodule InternAlbumWeb.PictureView do
  use InternAlbumWeb, :view
  alias InternAlbumWeb.PictureView

  def render("index.json", %{pictures: pictures}) do
    %{data: render_many(pictures, PictureView, "picture.json")}
  end

  def render("show.json", %{picture: picture}) do
    %{data: render_one(picture, PictureView, "picture.json")}
  end

  def render("picture.json", %{picture: picture}) do
    %{id: picture.id,
      folder: picture.folder,
      url: picture.url}
  end

  def render("success.json", _) do
    %{
      data: "ok"
    }
  end
end
