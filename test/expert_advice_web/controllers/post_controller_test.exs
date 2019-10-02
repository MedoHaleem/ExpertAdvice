defmodule ExpertAdviceWeb.PostControllerTest do
  use ExpertAdviceWeb.ConnCase, async: true

  alias ExpertAdvice.Accounts

  @create_attrs %{body: "some body", title: "some title", tags: "food"}
  @invalid_attrs %{body: nil, title: nil, tags: nil}

  def fixture(:post) do
    {:ok, post} = Accounts.create_post(@create_attrs)
    post
  end

  test "requires user authentication on all actions expect for index and show", %{conn: conn} do
    Enum.each([
      get(conn, Routes.post_path(conn, :new)),
      get(conn, Routes.post_path(conn, :edit, "test-me")),
      put(conn, Routes.post_path(conn, :update, "test-me", %{})),
      post(conn, Routes.post_path(conn, :create, %{})),
      delete(conn, Routes.post_path(conn, :delete, "test-me")),
    ], fn conn ->
      assert html_response(conn, 302)
      assert conn.halted
    end)
  end

  describe "with a logged-in user" do

    setup %{conn: conn, login_as: email} do
      user = user_fixture(email: email)
      conn = assign(conn, :current_user, user)

      {:ok, conn: conn, user: user}
    end

    @tag login_as: "medo@gmail.com"
    test "lists all questions on index", %{conn: conn, user: user} do
      user_post  = post_fixture(user, title: "help about something")
      other_post = post_fixture(user_fixture(email: "medo@email.com"), title: "another post")

      conn = get conn, Routes.post_path(conn, :index)
      response = html_response(conn, 200)
      assert response =~ user_post.title
      assert response =~ other_post.title
    end

    @tag login_as: "medo@gmail.com"
    test "creates user post and redirects", %{conn: conn, user: user} do
      create_conn = post conn, Routes.post_path(conn, :create), post: @create_attrs

      assert %{id: id} = redirected_params(create_conn)
      assert redirected_to(create_conn) == Routes.post_path(create_conn, :show, id)

      conn = get conn, Routes.post_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Question"

      assert Accounts.get_post!(id).user_id == user.id
    end

    @tag login_as: "medo@gmail.com"
    test "does not create post and renders errors when invalid", %{conn: conn} do
      conn = post conn, Routes.post_path(conn, :create), post: @invalid_attrs
      assert html_response(conn, 200) =~ "check the errors"
    end


  end

  test "authorizes actions against access by other users", %{conn: conn} do
    owner = user_fixture(email: "owner@email.com")
    post = post_fixture(owner, @create_attrs)
    non_owner = user_fixture(email: "notowner@email.com")
    conn = assign(conn, :current_user, non_owner)

    Enum.each([
      get(conn, Routes.post_path(conn, :edit, post)),
      put(conn, Routes.post_path(conn, :update, post, post: @create_attrs)),
      delete(conn, Routes.post_path(conn, :delete, post)),
    ], fn conn ->
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :error) == "You are not authorized to access that page"
    end)

  end

  describe "index" do
    test "lists all posts", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :index))
      assert html_response(conn, 200) =~ "get answers to difficult questions"
    end

    test "lists all posts with tags", %{conn: conn} do
      conn = get(conn, Routes.post_path(conn, :index,  %{"search" => %{"tag" => "food, diet"}}))
      assert html_response(conn, 200) =~ "get answers to difficult questions"
    end
  end
end
