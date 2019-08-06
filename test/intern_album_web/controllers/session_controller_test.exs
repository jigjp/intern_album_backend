defmodule InternAlbumWeb.SessionControllerTest do
  use InternAlbumWeb.ConnCase

  alias InternAlbum.Accounts

  @create_attrs %{
    icon_url: "some icon_url",
    name: "some name",
    credential: %{
      login_id: "some_login_id"
    }
  }

  @invalid_attrs %{
    login_id: nil,
    password: nil
  }

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create session" do
    test "renders user when data is valid", %{conn: conn} do
      fixture(:user)

      conn = post(conn, Routes.session_path(conn, :create), user: %{login_id: "some_login_id", password: "hoge"})
      assert %{"id" => id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "icon_url" => "some icon_url",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert %{"detail" => "Unauthorized"} = json_response(conn, 401)["errors"]
    end
  end

end
