defmodule ExpertAdvice.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema("users") do
    field(:name, :string)
    field(:email, :string)
    field(:password, :string, virtual: true)
    field(:password_hash, :string)

    timestamps()
  end

  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :email])
    |> validate_required([:name, :email])
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email, message: "This email is already taken")
  end

  def registration_changeset(user, params) do
    user
    |> changeset(params)
    |> cast(params, [:password])
    |> validate_length(:password, min: 6, message: "The password is too short")
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: pass}} ->
        put_change(changeset, :password_hash, Pbkdf2.hash_pwd_salt(pass))
      _ -> changeset
    end
  end
end
