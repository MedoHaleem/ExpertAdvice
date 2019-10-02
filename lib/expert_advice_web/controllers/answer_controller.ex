defmodule ExpertAdviceWeb.AnswerController do
  use ExpertAdviceWeb, :controller

  alias ExpertAdvice.Accounts

  def create(conn, %{"post_id" => post_id, "post" => post_params}, current_user) do
    post = Accounts.get_post!(post_id)
    case Accounts.create_answer(current_user, post, post_params) do
      {:ok, _answer} ->
        conn
        |> put_flash(:info, "Answer created successfully.")
        |> redirect(to: Routes.post_path(conn, :show, post))

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect changeset
        conn
        |> put_flash(:error, "Issue creating comment.")
        |> redirect(to: Routes.post_path(conn, :show, post))
    end
  end

  def action(conn, _) do
    args = [conn, conn.params, conn.assigns.current_user]
    apply(__MODULE__, action_name(conn), args)
  end
end
