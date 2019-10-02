defmodule ExpertAdviceWeb.PostController do
  use ExpertAdviceWeb, :controller

  alias ExpertAdvice.Accounts
  alias ExpertAdvice.Accounts.Post

  plug :authenticate_user when action in [:new, :create, :edit, :update, :delete]
  plug :authorize_user when action in [:edit, :update, :delete]

  def index(conn, params, _current_user) do
    page = Accounts.list_posts(params)
    IO.inspect page.entries
    render(conn, "index.html", posts: page.entries, page: page)
  end

  def new(conn, _params, _current_user) do
    changeset = Accounts.change_post(%Post{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"post" => post_params}, current_user) do
    case Accounts.create_question(current_user, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post created successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}, _current_user) do
    post = Accounts.get_post!(id)
    answer_changeset = Accounts.change_answer(%Post{})
    render(conn, "show.html", post: post, answer_changeset: answer_changeset)
  end

  def edit(conn, %{"id" => id}, current_user) do
    post = Accounts.get_user_question!(current_user, id)
    changeset = Accounts.change_post(post)
    render(conn, "edit.html", post: post, changeset: changeset)
  end

  def update(conn, %{"id" => id, "post" => post_params}, current_user) do
    post = Accounts.get_user_question!(current_user, id)

    case Accounts.update_post(post, post_params) do
      {:ok, post} ->
        conn
        |> put_flash(:info, "Post updated successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", post: post, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    post = Accounts.get_post!(id)
    {:ok, _post} = Accounts.delete_post(post)

    conn
    |> put_flash(:info, "Post deleted successfully.")
    |> redirect(to: Routes.post_path(conn, :index))
  end

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end

  defp authorize_user(conn, _params) do
    %{params: %{"id" => post_id}} = conn
    post = Accounts.get_post!(post_id)

    if conn.assigns.current_user.id == post.user_id do
      conn
    else
      conn
      |> put_flash(:error, "You are not authorized to access that page")
      |> redirect(to: Routes.post_path(conn, :index))
      |> halt()
    end
  end

end
