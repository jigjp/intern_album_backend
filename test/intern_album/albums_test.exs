defmodule InternAlbum.AlbumsTest do
  use InternAlbum.DataCase

  alias InternAlbum.Albums

  describe "pictures" do
    alias InternAlbum.Albums.Picture

    @valid_attrs %{folder: "some folder", url: "some url"}
    @update_attrs %{folder: "some updated folder", url: "some updated url"}
    @invalid_attrs %{folder: nil, url: nil}

    def picture_fixture(attrs \\ %{}) do
      {:ok, picture} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Albums.create_picture()

      picture
    end

    test "list_pictures/0 returns all pictures" do
      picture = picture_fixture()
      assert Albums.list_pictures() == [picture]
    end

    test "get_picture!/1 returns the picture with given id" do
      picture = picture_fixture()
      assert Albums.get_picture!(picture.id) == picture
    end

    test "create_picture/1 with valid data creates a picture" do
      assert {:ok, %Picture{} = picture} = Albums.create_picture(@valid_attrs)
      assert picture.folder == "some folder"
      assert picture.url == "some url"
    end

    test "create_picture/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Albums.create_picture(@invalid_attrs)
    end

    test "update_picture/2 with valid data updates the picture" do
      picture = picture_fixture()
      assert {:ok, %Picture{} = picture} = Albums.update_picture(picture, @update_attrs)
      assert picture.folder == "some updated folder"
      assert picture.url == "some updated url"
    end

    test "update_picture/2 with invalid data returns error changeset" do
      picture = picture_fixture()
      assert {:error, %Ecto.Changeset{}} = Albums.update_picture(picture, @invalid_attrs)
      assert picture == Albums.get_picture!(picture.id)
    end

    test "delete_picture/1 deletes the picture" do
      picture = picture_fixture()
      assert {:ok, %Picture{}} = Albums.delete_picture(picture)
      assert_raise Ecto.NoResultsError, fn -> Albums.get_picture!(picture.id) end
    end

    test "change_picture/1 returns a picture changeset" do
      picture = picture_fixture()
      assert %Ecto.Changeset{} = Albums.change_picture(picture)
    end
  end
end
