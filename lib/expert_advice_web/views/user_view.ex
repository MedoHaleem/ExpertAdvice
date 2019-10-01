defmodule ExpertAdviceWeb.UserView do
  use ExpertAdviceWeb, :view
  alias ExpertAdvice.Accounts

  def first_name(%Accounts.User{name: name}) do
    name
    |> String.split(" ")
    |> Enum.at(0)
  end
end
