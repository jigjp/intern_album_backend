defmodule InternAlbumWeb.FolderControllerTest do
  use InternAlbumWeb.ConnCase

  alias InternAlbum.Albums
  alias InternAlbum.Albums.Folder
  alias InternAlbum.Accounts

  @create_user_attrs %{
    icon_url: "some icon_url",
    name: "some name"
  }

  @create_attrs %{
    "image" => %Plug.Upload{path: "test/fixtures/example.png", filename: "example.png"}
  }

  def fixture(:picture, attr) do
    {:ok, picture} = Albums.create_picture(attr)
    picture
  end

  setup %{conn: conn} do
    {:ok, user} = Accounts.create_user(@create_user_attrs)

    conn = session_conn()
    |> put_session(:user_id, user.id)
    |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  describe "index" do

    setup [:create_pictures]

    test "lists all folders", %{conn: conn, pictures: pictures} do
      conn = get(conn, Routes.folder_path(conn, :index))
      assert json_response(conn, 200)["data"] == ["2019/8/1", "2019/8/2"]
    end
  end

  def create_pictures(_) do
    pictures = ["2019/8/1", "2019/8/2"]
    |> Enum.map(fn folder ->
      attr = Map.put(@create_attrs, "folder", folder)
      fixture(:picture, attr)
    end)

    {:ok, pictures: pictures}
  end

end
