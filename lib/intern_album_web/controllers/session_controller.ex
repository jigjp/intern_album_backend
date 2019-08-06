defmodule InternAlbumWeb.SessionController do
  use InternAlbumWeb, :controller

  alias InternAlbum.Accounts

  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"login_id" => login_id, "password" => password}}) do
    case Accounts.authenticate_by_login_id_password(login_id, password) do
      {:ok, user} ->
        conn
        |> put_session(:user_id, user.id)
        |> configure_session(renew: true)
        |> put_view(InternAlbumWeb.UserView)
        |> render("show.json", user: user)
      {:error, :unauthorized} ->
        conn
        |> put_view(InternAlbumWeb.ErrorView)
        |> render("401.json", message: "ログインIDもしくはパスワードが間違っています")
    end
  end
end
