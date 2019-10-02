defmodule ExpertAdvice.Accounts.Tag do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tags" do
    field :name, :string
    many_to_many :posts, ExpertAdvice.Accounts.Post, join_through: "posts_tags"

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end


end
