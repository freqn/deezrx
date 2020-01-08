defmodule Deezrx.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias Deezrx.Accounts.User

  schema "users" do
    field(:email, :string)
    field(:password_hash, :string)
    field(:org_id, :integer, default: 0)
    field(:is_pharmacy, :boolean, default: false)
    field(:is_courier, :boolean, default: false)
    field(:is_admin, :boolean, default: false)
    field(:password, :string, virtual: true)
    timestamps()
  end

  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:email, :password, :org_id, :is_pharmacy, :is_courier, :is_admin])
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

  def pharmacy_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:is_pharmacy])
  end

  def courier_changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:is_courier])
  end
end
