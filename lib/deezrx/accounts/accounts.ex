defmodule Deezrx.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Deezrx.Repo

  alias Deezrx.Accounts.Courier
  alias Deezrx.Accounts.Pharmacy
  alias Deezrx.Accounts.Order
  alias Deezrx.Accounts.User

  def list_couriers do
    Repo.all(Courier)
  end

  def get_courier!(id), do: Repo.get!(Courier, id)

  def create_courier(attrs \\ %{}) do
    %Courier{}
    |> Courier.changeset(attrs)
    |> Repo.insert()
  end

  def update_courier(%Courier{} = courier, attrs) do
    courier
    |> Courier.changeset(attrs)
    |> Repo.update()
  end

  def delete_courier(%Courier{} = courier) do
    Repo.delete(courier)
  end

  def change_courier(%Courier{} = courier) do
    Courier.changeset(courier, %{})
  end

  def list_orders() do
    Repo.all(Order)
  end

  alias Deezrx.Accounts.User

  def list_users do
    Repo.all(User)
  end

  def get_user!(id) do
    Repo.get!(User, id)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  def new_user() do
    User.changeset(%User{}, %{})
  end

  def authenticate_user(email, password) do
    Repo.get_by(User, email: email)
    |> User.check_password(password)
  end
end
