defmodule ExpertAdvice.AccountsTest do
  use ExpertAdvice.DataCase

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

    @valid_attrs %{title: "some slug", body: "some body"}
    @update_attrs %{title: "some updated title", body: "some updated body"}
    @invalid_attrs %{body: nil, title: nil}


  end
end
