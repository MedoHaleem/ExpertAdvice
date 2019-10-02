defmodule ExpertAdvice.AccountsTest do
  use ExpertAdvice.DataCase, async: true

  alias ExpertAdvice.Accounts
  alias ExpertAdvice.Accounts.{User, Tag, Post}

  describe "register_user/1" do
    @valid_attrs %{name: "Medo", email: "medo.a.haleem@gmail.com", password: "password"}
    @invalid_attrs %{}

    test "with valid data inserts user" do
      assert {:ok, %User{id: id} = user} = Accounts.register_user(@valid_attrs)
      assert user.name == "Medo"
      assert user.email == "medo.a.haleem@gmail.com"
    end

    test "with invalid data not to inserts user" do
     assert {:error, _changeset} = Accounts.register_user(@invalid_attrs)
    end

    test "enforce unique email" do
      assert {:ok, %User{id: id}} = Accounts.register_user(@valid_attrs)
      assert {:error, changeset} = Accounts.register_user(@valid_attrs)
      assert %{email: ["This email is already taken"]} = errors_on(changeset)
    end

    test "doesn't accpet wronng email format" do
      attrs = Map.put(@valid_attrs, :email, "medo")
      assert {:error, changeset} = Accounts.register_user(attrs)
      assert %{email: ["has invalid format"]} = errors_on(changeset)
    end

    test "require password to be at least 6 chars long" do
      attrs = Map.put(@valid_attrs, :password, "12345")
      assert {:error, changeset} = Accounts.register_user(attrs)
      assert %{password: ["The password is too short"]} = errors_on(changeset)
    end
  end

  describe "authenticate_by_email_and_pass/2" do
    @pass "123456"

    setup do
      {:ok, user: user_fixture(password: @pass)}
    end

    test "returns user with correct password", %{user: user} do
      assert {:ok, auth_user} =
             Accounts.authenticate_by_email_and_pass(user.email, @pass)

      assert auth_user.id == user.id
    end

    test "returns unauthorized error with invalid password", %{user: user} do
      assert {:error, :unauthorized} =
             Accounts.authenticate_by_email_and_pass(user.email, "badpass")
    end

    test "returns not found error with no matching user for email" do
      assert {:error, :not_found} =
             Accounts.authenticate_by_email_and_pass("unknownuser", @pass)
    end
  end

  describe "Tags" do
    test "create tags" do
      for name <- ~w(Food Diet Fitness) do
        Accounts.create_tag(%{name: name})
      end
      tags = for %Tag{name: name} <- Accounts.list_tags() do
        name
      end

      assert tags == ~w(Food Diet Fitness)
    end
  end

  describe "posts" do
    alias ExpertAdvice.Accounts.Post

    @valid_attrs %{title: "some title", body: "some body"}
    @invalid_attrs %{body: nil, title: nil}

    test "list_posts/0 returns all posts" do
      owner = user_fixture()
      %Post{id: id1} = post_fixture(owner)
      page = Accounts.list_posts(%{}, "")
      assert [%Post{id: ^id1}] = page.entries
    end

    test "get_post!/1 returns the post with given id" do
      owner = user_fixture()
      %Post{slug: slug} = post_fixture(owner)
      assert %Post{slug: ^slug} = Accounts.get_post!(slug)
    end

     test "create_question/2 with valid data creates a question" do
      owner = user_fixture()
       assert {:ok, %Post{} = post} = Accounts.create_question(owner, @valid_attrs)
       assert post.body == "some body"
       assert post.title == "some title"
       assert post.slug == "some-title"
     end

     test "create_question/2 with invalid data returns error changeset" do
       owner = user_fixture()
       assert {:error, %Ecto.Changeset{}} = Accounts.create_question(owner, @invalid_attrs)
     end

     test "update_post/2 with valid data updates the post" do
       owner = user_fixture()
       post = post_fixture(owner)
       assert {:ok, post} = Accounts.update_post(post, %{title: "updated title"})
       assert %Post{} = post
       assert post.title == "updated title"
     end

     test "update_post/2 with invalid data returns error changeset" do
       owner = user_fixture()
       %Post{slug: slug} = post = post_fixture(owner)
       assert {:error, %Ecto.Changeset{}} = Accounts.update_post(post, @invalid_attrs)
       assert %Post{slug: ^slug} = Accounts.get_post!(slug)
     end

     test "delete_post/1 deletes the post" do
       owner = user_fixture()
       post = post_fixture(owner)
       assert {:ok, %Post{}} = Accounts.delete_post(post)
       page = Accounts.list_posts(%{}, "")
       assert page.entries == []
     end

     test "change_post/1 returns a post changeset" do
       owner = user_fixture()
       post = post_fixture(owner)
       assert %Ecto.Changeset{} = Accounts.change_post(post)
     end

  end
end
