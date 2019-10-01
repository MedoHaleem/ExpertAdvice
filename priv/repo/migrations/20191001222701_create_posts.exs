defmodule ExpertAdvice.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :title, :string
      add :slug, :string
      add :body, :text
      add :user_id, references(:users, on_delete: :delete_all)
      add :post_id, references(:posts, on_delete: :delete_all)

      timestamps()
    end

    create unique_index(:posts, [:title])
    create index(:posts, [:user_id])
    create index(:posts, [:post_id])
  end
end
