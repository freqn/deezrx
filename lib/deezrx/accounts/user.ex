defmodule Deezrx.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Deezrx.Accounts.User

  schema "users" do
    field(:email, :string)
    field(:password_hash, :string)
    field(:org_id, :integer)
    field(:is_pharmacy, :boolean)
    field(:is_courier, :boolean)
    field(:password, :string, virtual: true)
    timestamps()
  end

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password, :org_id, :is_pharmacy, :is_courier])
    |> validate_required([:email, :password])
    |> validate_length(:password, min: 6)
    |> unique_constraint(:email)
    |> put_password_hash()
  end

  defp put_password_hash(changeset = %{valid?: true}) do
    password = get_change(changeset, :password)
    change(changeset, Bcrypt.add_hash(password))
  end

  defp put_password_hash(changeset) do
    changeset
  end

  def check_password(user, password) do
    Bcrypt.check_pass(user, password)
  end
end
