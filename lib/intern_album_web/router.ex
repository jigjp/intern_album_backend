defmodule InternAlbumWeb.Router do
  use InternAlbumWeb, :router

  defp authenticate_user(conn, _) do
    case get_session(conn, :user_id) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> put_view(InternAlbumWeb.ErrorView)
        |> render("401.json", message: "Unauthorized user")
        |> halt()
      user_id ->
        assign(conn, :current_user, InternAlbum.Accounts.get_user!(user_id))
    end
  end

  pipeline :api do
    plug CORSPlug, origin: ["http://localhost:8080"]
    plug :accepts, ["json"]
    plug :fetch_session
  end

  scope "/api", InternAlbumWeb do
    pipe_through :api

    options "/sessions", SessionController, :options
    resources "/sessions", SessionController, only: [:new, :create], singleton: true
  end

  scope "/api", InternAlbumWeb do
    pipe_through [:api, :authenticate_user]

    options "/users", UserController, :options
    resources "/users", UserController, except: [:new, :edit]

    options "/pictures", PictureController, :options
    resources "/pictures", PictureController, except: [:new, :edit]
  end
end
