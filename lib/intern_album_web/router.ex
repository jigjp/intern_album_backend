defmodule InternAlbumWeb.Router do
  use InternAlbumWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", InternAlbumWeb do
    pipe_through :api
  end
end
