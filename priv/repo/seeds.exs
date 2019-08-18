# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     InternAlbum.Repo.insert!(%InternAlbum.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias InternAlbum.Accounts
alias InternAlbum.Albums

# ユーザー作成
create_user_attrs = %{
  icon_url: "some icon_url",
  name: "some name",
  credential: %{
    login_id: "some_login_id"
  }
}

Accounts.create_user(create_user_attrs)

# 写真作成
create_picture_attrs = %{
  "image" => %Plug.Upload{path: "test/fixtures/example.png", filename: "example.png"}
}

["2019/8/1", "2019/8/2"]
|> Enum.map(fn folder ->
  attr = Map.put(create_picture_attrs, "folder", folder)
  Albums.create_picture(attr)
end)
|> IO.inspect
