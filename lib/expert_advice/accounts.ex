defmodule ExpertAdvice.Accounts do

  import Ecto.Query, warn: false

  alias ExpertAdvice.Accounts.User
  alias ExpertAdvice.Repo


  def get_user(id) do
    Repo.get(User, id)
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def get_user_by(params) do
    Repo.get_by(User, params)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def create_user(attrs \\ %{}) do
    %User{} |> User.changeset(attrs) |> Repo.insert()
  end

  def change_registration(%User{}= user, params) do
    User.registration_changeset(user, params)
  end

  def register_user(attrs \\ %{}) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert()
  end

  def authenticate_by_email_and_pass(email, given_pass) do
    user = get_user_by(email: email)

    cond do
      user && Pbkdf2.verify_pass(given_pass, user.password_hash) ->
        {:ok, user}
      user ->
        {:error, :unauthorized}
      true -> Pbkdf2.no_user_verify()
        {:error, :not_found}
    end
  end

  alias ExpertAdvice.Accounts.Post

  def list_posts(params, tags) do
    Post |> Post.newest_question(tags) |> preload(:tags) |> Repo.paginate(params)
  end


  def get_post!(slug) do
    Post
    |> Repo.get_by!(%{slug: slug})
    |> Repo.preload([:answers, :tags])
  end

  def get_user_question!(%User{} = user, slug) do
    Post
    |> user_questions_query(user)
    |> Repo.get_by!(%{slug: slug})
    |> Repo.preload(:tags)
  end

  defp user_questions_query(query, %User{id: user_id}) do
    from(q in query, where: q.user_id == ^user_id)
  end

  def create_question(%User{} = user, attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  def create_answer(%User{} = user, %Post{} = post, attrs \\ %{}) do
    %Post{}
    |> Post.answer_changeset(attrs)
    |> Ecto.Changeset.put_assoc(:post, post)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end


  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end


  def delete_post(%Post{} = post) do
    Repo.delete(post)
  end


  def change_post(%Post{} = post) do
    Post.changeset(post, %{})
  end

  def change_answer(%Post{} = post) do
    Post.answer_changeset(post, %{})
  end


  alias ExpertAdvice.Accounts.PostsTags
  alias ExpertAdvice.Accounts.Tag

  def list_tags do
    Repo.all(Tag)
   end

  def change_tag(%Tag{} = tag) do
    Tag.changeset(tag, %{})
  end
  def create_tag(attrs \\ %{}) do
    %Tag{} |> Tag.changeset(attrs) |> Repo.insert()
  end


  def add_tag(post, tag_name) when is_binary(tag_name) and byte_size(tag_name) > 0  do
    tag =
      case Repo.get_by(Tag, %{name: tag_name}) do
        nil ->
          %Tag{} |> Tag.changeset(%{name: tag_name}) |> Repo.insert!()
        tag ->
          tag
      end
      add_tag(post, tag.id)
  end
  def add_tag(%Post{} = post, tid) do
    add_tag(post.id, tid)
   end

   def add_tag(%{post_id: pid}, tid) do
    add_tag(pid, tid)
   end

  def add_tag(pid, tid) do
    %PostsTags{} |> PostsTags.changeset(%{post_id: pid, tag_id: tid}) |> Repo.insert()
  end


  def add_tags(post, tags) do
    tags |> String.split(", ") |> Enum.each(&add_tag(post, &1))
  end
  def remove_tag(post, tag_name) when is_binary(tag_name) do
      case Repo.get_by(Tag, %{name: tag_name}) do
        nil -> nil
        tag -> remove_tag(post, tag.id)
      end
  end

  def remove_tag(%Post{} = post, tid) do
    remove_tag(post.id, tid)
   end

   def remove_tag(%{post_id: pid}, tid) do
    remove_tag(pid, tid)
   end

  def remove_tag(pid, tid) do
    case Repo.get_by(PostsTags, %{post_id: pid, tag_id: tid}) do
       nil-> nil
       tag -> Repo.delete(tag)
    end
  end

  def tags_loaded(%{tags: tags}) do
    tags |> Enum.map_join(", ", & &1.name)
  end

  def update_tags(post, new_tags) when is_binary(new_tags) do
    old_tags = tags_loaded(post) |> String.split(", ")
    new_tags = new_tags |> String.split(", ")
    Enum.each(new_tags -- old_tags, &add_tag(post, &1))
    Enum.each(old_tags -- new_tags, &remove_tag(post, &1))
  end

end
