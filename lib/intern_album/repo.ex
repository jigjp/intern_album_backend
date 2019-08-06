defmodule InternAlbum.Repo do
  use Ecto.Repo,
    otp_app: :intern_album,
    adapter: Ecto.Adapters.MySQL
end
