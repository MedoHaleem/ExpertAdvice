defmodule ExpertAdvice.TestHelpers do
  alias ExpertAdvice.Accounts
  def user_fixture(attrs \\ %{}) do
    {:ok, user} = attrs
    |> Enum.into(%{
      name: "Medo Haleem",
      email: "test#{System.unique_integer([:positive])}@email.com",
      password: attrs[:password] || "password"
    }) |> Accounts.register_user

    user
  end
  def post_fixture(%Accounts.User{} = user, attrs \\ %{}) do
    attrs =
    Enum.into(attrs, %{
      title: "A Question",
      body: "something about something number#{System.unique_integer([:positive])}"
    })
    {:ok, post} = Accounts.create_question(user, attrs)

    post
  end
end
