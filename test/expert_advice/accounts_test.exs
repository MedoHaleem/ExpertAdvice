defmodule ExpertAdvice.AccountsTest do
  use ExpertAdvice.DataCase

  alias ExpertAdvice.Accounts

  describe "posts" do
    alias ExpertAdvice.Accounts.Post

    @valid_attrs %{body: "some body", slug: "some slug", title: "some title"}
    @update_attrs %{body: "some updated body", slug: "some updated slug", title: "some updated title"}
    @invalid_attrs %{body: nil, slug: nil, title: nil}

    def post_fixture(attrs \\ %{}) do
      {:ok, post} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_post()

      post
    end

    test "list_posts/0 returns all posts" do
      post = post_fixture()
      assert Accounts.list_posts() == [post]
    end

    test "get_post!/1 returns the post with given id" do
      post = post_fixture()
      assert Accounts.get_post!(post.id) == post
    end

    test "create_post/1 with valid data creates a post" do
      assert {:ok, %Post{} = post} = Accounts.create_post(@valid_attrs)
      assert post.body == "some body"
      assert post.slug == "some slug"
      assert post.title == "some title"
    end

    test "create_post/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_post(@invalid_attrs)
    end

    test "update_post/2 with valid data updates the post" do
      post = post_fixture()
      assert {:ok, %Post{} = post} = Accounts.update_post(post, @update_attrs)
      assert post.body == "some updated body"
      assert post.slug == "some updated slug"
      assert post.title == "some updated title"
    end

    test "update_post/2 with invalid data returns error changeset" do
      post = post_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_post(post, @invalid_attrs)
      assert post == Accounts.get_post!(post.id)
    end

    test "delete_post/1 deletes the post" do
      post = post_fixture()
      assert {:ok, %Post{}} = Accounts.delete_post(post)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_post!(post.id) end
    end

    test "change_post/1 returns a post changeset" do
      post = post_fixture()
      assert %Ecto.Changeset{} = Accounts.change_post(post)
    end
  end
end
