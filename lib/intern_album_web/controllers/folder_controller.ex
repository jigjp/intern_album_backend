defmodule InternAlbumWeb.FolderController do
  use InternAlbumWeb, :controller

  alias InternAlbum.Albums
  alias InternAlbum.Albums.Folder

  action_fallback InternAlbumWeb.FallbackController

  def index(conn, _params) do
    folders = Albums.list_folders()
    render(conn, "index.json", folders: folders)
  end
end
