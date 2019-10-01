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
    |> process_slug
  end

  defp process_slug(%Ecto.Changeset{valid?: validity, changes: %{title: title}} = changeset) do
    case validity do
      true -> put_change(changeset, :slug, Slugger.slugify_downcase(title))
      false -> changeset
    end
  end

  defp process_slug(changeset), do: changeset
end
