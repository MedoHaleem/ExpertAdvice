defmodule ExpertAdviceWeb.SessionController do
  use ExpertAdviceWeb, :controller
  def new(conn, _) do
    render(conn, "new.html")
  end

  def create(conn, %{"session" => %{"email" => email, "password" => pass}}) do
    case ExpertAdvice.Accounts.authenticate_by_email_and_pass(email, pass) do
      {:ok, user} ->
        conn
        |> ExpertAdviceWeb.Auth.login(user)
        |> put_flash(:info, "Welcome back!")
        |> redirect(to: Routes.post_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Invalid email/password combination")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> ExpertAdviceWeb.Auth.logout()
    |> redirect(to: Routes.post_path(conn, :index))
  end
end
