defmodule ExpertAdvice.Accounts.PostsTags do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts_tags" do
    belongs_to :post, ExpertAdvice.Accounts.Post
    belongs_to :tag, ExpertAdvice.Accounts.Tag
    timestamps()
  end

  @doc false
  def changeset(posts_tags, attrs) do
    posts_tags
    |> cast(attrs, [:post_id, :tag_id])
    |> validate_required([:post_id, :tag_id])
  end


end
