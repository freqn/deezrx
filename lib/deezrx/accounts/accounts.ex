defmodule Deezrx.Accounts do
  import Ecto.Query, warn: false
  alias Deezrx.{Repo, Accounts}

  alias Accounts.{
    Courier,
    Pharmacy,
    Order,
    User
  }

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

  # Pharmacies

  def list_pharmacies do
    Repo.all(Pharmacy)
  end

  def get_pharmacy!(id), do: Repo.get!(Pharmacy, id)

  def create_pharmacy(attrs \\ %{}) do
    %Pharmacy{}
    |> Pharmacy.changeset(attrs)
    |> Repo.insert()
  end

  def update_pharmacy(%Pharmacy{} = pharmacy, attrs) do
    pharmacy
    |> Pharmacy.changeset(attrs)
    |> Repo.update()
  end

  def delete_pharmacy(%Pharmacy{} = pharmacy) do
    Repo.delete(pharmacy)
  end

  def change_pharmacy(%Pharmacy{} = pharmacy) do
    Pharmacy.changeset(pharmacy, %{})
  end

  # Orders

  def list_orders do
    Repo.all(Order)
  end

  def get_order(id), do: Repo.get!(Order, id)

  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  def change_order(order \\ %Order{}) do
    Order.changeset(order, %{})
  end

  # Users

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
