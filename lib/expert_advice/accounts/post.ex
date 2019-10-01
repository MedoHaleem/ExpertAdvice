defmodule ExpertAdvice.Accounts.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
    field :body, :string
    field :slug, :string
    field :title, :string
    belongs_to :user, ExpertAdvice.Accounts.User
    belongs_to :post, ExpertAdvice.Accounts.Post

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :slug, :body])
    |> validate_required([:title, :slug, :body])
    |> unique_constraint(:title)
    |> assoc_constraint(:user)
  end
end
