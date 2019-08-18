defmodule InternAlbumWeb.PictureControllerTest do
  use InternAlbumWeb.ConnCase

  alias InternAlbum.Albums
  alias InternAlbum.Albums.Picture
  alias InternAlbum.Accounts

  @create_user_attrs %{
    icon_url: "some icon_url",
    name: "some name"
  }
  @create_attrs %{
    folder: "some folder",
    image: %Plug.Upload{path: "test/fixtures/example.png", filename: "example.png"}
  }
  @update_attrs %{
    folder: "some updated folder",
    url: "some updated url"
  }
  @invalid_attrs %{folder: nil, url: nil}

  def fixture(:picture) do
    {:ok, picture} = Albums.create_picture(@create_attrs)
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
    test "lists folder pictures", %{conn: conn} do
      conn = get(conn, Routes.picture_path(conn, :index, "hogehoge"))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create picture" do
    test "renders picture when data is valid", %{conn: conn} do
      conn = post(conn, Routes.picture_path(conn, :create), picture: @create_attrs)
      assert "ok" = json_response(conn, 201)["data"]

      conn = get(conn, Routes.picture_path(conn, :index, "some folder"))

      res = json_response(conn, 200)["data"]

      assert [%{
               "id" => id,
               "folder" => "some folder",
               "url" => "/media/" <> filename
             }] = res

      assert :ok = File.rm("media/#{filename}")
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.picture_path(conn, :create), picture: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  # describe "update picture" do
  #   setup [:create_picture]

  #   test "renders picture when data is valid", %{conn: conn, picture: %Picture{id: id} = picture} do
  #     conn = put(conn, Routes.picture_path(conn, :update, picture), picture: @update_attrs)
  #     assert %{"id" => ^id} = json_response(conn, 200)["data"]

  #     conn = get(conn, Routes.picture_path(conn, :show, id))

  #     assert %{
  #              "id" => id,
  #              "folder" => "some updated folder",
  #              "url" => "some updated url"
  #            } = json_response(conn, 200)["data"]
  #   end

  #   test "renders errors when data is invalid", %{conn: conn, picture: picture} do
  #     conn = put(conn, Routes.picture_path(conn, :update, picture), picture: @invalid_attrs)
  #     assert json_response(conn, 422)["errors"] != %{}
  #   end
  # end

  # describe "delete picture" do
  #   setup [:create_picture]

  #   test "deletes chosen picture", %{conn: conn, picture: picture} do
  #     conn = delete(conn, Routes.picture_path(conn, :delete, picture))
  #     assert response(conn, 204)

  #     assert_error_sent 404, fn ->
  #       get(conn, Routes.picture_path(conn, :show, picture))
  #     end
  #   end
  # end

  defp create_picture(_) do
    picture = fixture(:picture)
    {:ok, picture: picture}
  end
end
