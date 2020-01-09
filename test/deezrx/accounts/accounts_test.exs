defmodule Deezrx.AccountsTest do
  use Deezrx.DataCase

  alias Deezrx.Accounts
  alias Accounts.User

  @pharmacy_attrs %{
    name: "BetterRx",
    address: "1275 Kinnear Road, Columbus, OH 43212"
  }

  @user_attrs %{
    email: "betterrx@test.com",
    password: "123456"
  }

  @order_attrs %{
    patient_first_name: "Jerry",
    patient_last_name: "Hangover",
    patient_address: "60 Nixon Blvd, Watergate, NH, 13302",
    pickup_date: Date.utc_today(),
    pickup_time: ~T[02:15:15],
    active: true,
    delivered: false,
    undeliverable: false
  }

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@user_attrs)
      |> Accounts.create_user()

    user
  end

  def pharmacy_fixture(attrs \\ %{}) do
    {:ok, pharmacy} =
      attrs
      |> Enum.into(@pharmacy_attrs)
      |> Accounts.create_pharmacy()

    pharmacy
  end

  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(@order_attrs)
      |> Accounts.create_order()

    order
  end

  describe "accounts_users" do
    test "create_user/1 creates a user when data is valid" do
      assert {:ok, user} = Accounts.create_user(@user_attrs)
    end

    test "create_user/1 does not create a user when data is invalid" do
      existing = user_fixture()
      {:error, changeset} = Accounts.create_user(%{})

      assert "can't be blank" in errors_on(changeset).email
      assert "can't be blank" in errors_on(changeset).password

      {:error, changeset} = Accounts.create_user(%{password: "123"})
      assert "should be at least 6 character(s)" in errors_on(changeset).password

      duplicated_email_attrs = %{@user_attrs | email: existing.email}
      {:error, changeset} = Accounts.create_user(duplicated_email_attrs)

      assert "has already been taken" in errors_on(changeset).email
    end

    test "get_user!/1 returns a user" do
      fixture = user_fixture()
      user = Accounts.get_user!(fixture.id)

      assert user.id == fixture.id
    end

    test "new_user/0 returns an empty changeset" do
      assert %Ecto.Changeset{} = Accounts.new_user()
    end

    test "authenticate_user/2 returns a user when email and password match" do
      user_fixture()

      assert {:ok, %User{}} = Accounts.authenticate_user(@user_attrs.email, @user_attrs.password)
    end

    test "authenticate_user/2 returns an error when email is not found" do
      user_fixture()

      assert {:error, "invalid password"} =
               Accounts.authenticate_user(@user_attrs.email, "invalid")
    end

    test "authenticate_user/2 returns an error when password doesn't match" do
      user_fixture()

      assert {:error, "invalid password"} =
               Accounts.authenticate_user(@user_attrs.email, "invalid")
    end
  end

  describe "accounts_orders" do
    test "create_order/1 creates an order when data is valid" do
      order = order_fixture()

      {:error, changeset} = Accounts.create_order(%{})

      assert "can't be blank" in errors_on(changeset).patient_first_name
      assert "can't be blank" in errors_on(changeset).patient_last_name
      assert "can't be blank" in errors_on(changeset).patient_address
      assert "can't be blank" in errors_on(changeset).pickup_date
      assert "can't be blank" in errors_on(changeset).pickup_time

      {:ok, first_order} =
        Accounts.create_order(%{
          patient_first_name: "Jerry",
          patient_last_name: "Hangover",
          patient_address: "60 Nixon Blvd, Watergate, NH, 13302",
          pickup_date: Date.utc_today(),
          pickup_time: ~T[02:15:15]
        })

      assert first_order.patient_first_name == order.patient_first_name
      assert first_order.patient_last_name == order.patient_last_name
      assert first_order.patient_address == order.patient_address
      assert first_order.pickup_date == order.pickup_date
      assert first_order.pickup_time == order.pickup_time
    end

    test "update_order/2 updates an order when order is valid" do
      order = order_fixture()
      new_attrs = %{patient_first_name: "Joan", delivered: true}

      assert {:ok, order} = Accounts.update_order(order, new_attrs)
    end

    test "get_order!/1 fetches an order" do
      order = order_fixture()
      fetched_order = Accounts.get_order!(order.id)

      assert fetched_order.id == order.id
    end

    test "cancels an order" do
      order = order_fixture()
      new_attrs = %{active: false}

      assert {:ok, order} = Accounts.update_order(order, new_attrs)
      assert order.active == false
    end

    test "delivers an order" do
      order = order_fixture()
      new_attrs = %{delivered: true}

      assert {:ok, order} = Accounts.update_order(order, new_attrs)
      assert order.delivered == true
    end

    test "marks an order as undeliverable" do
      order = order_fixture()
      new_attrs = %{undeliverable: true}

      assert {:ok, order} = Accounts.update_order(order, new_attrs)
      assert order.undeliverable == true
    end
  end
end
