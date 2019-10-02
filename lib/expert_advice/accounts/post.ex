defmodule ExpertAdvice.Accounts.Post do
  use Ecto.Schema
  import Ecto.Query
  import Ecto.Changeset

  @derive {Phoenix.Param, key: :slug}

  schema "posts" do
    field :title, :string
    field :body, :string
    field :slug, :string
    belongs_to :user, ExpertAdvice.Accounts.User
    belongs_to :post, ExpertAdvice.Accounts.Post
    has_many :answers, ExpertAdvice.Accounts.Post, foreign_key: :post_id

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:title, :body])
    |> validate_required([:title, :body])
    |> assoc_constraint(:user)
    |> process_slug
  end

  def answer_changeset(post, attrs) do
    post
    |> cast(attrs, [:body])
    |> validate_required([:body])
    |> assoc_constraint(:user)
    |> assoc_constraint(:post)
  end


  defp process_slug(%Ecto.Changeset{valid?: validity, changes: %{title: title}} = changeset) do
    case validity do
      true -> put_change(changeset, :slug, Slugger.slugify_downcase(title))
      false -> changeset
    end
  end

  defp process_slug(changeset), do: changeset

  def newest_question(query) do
    from q in query, where: is_nil(q.post_id), order_by: [desc: q.inserted_at]
  end
end
