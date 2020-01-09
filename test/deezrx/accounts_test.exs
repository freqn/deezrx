defmodule Deezrx.AccountsTest do
  use Deezrx.DataCase

  alias Deezrx.Accounts
  alias Accounts.User

  @user_attrs %{
    email: "betterrx@test.com",
    password: "123456"
  }

  @pharmacy_attrs %{
    name: "BetterRx",
    address: "1275 Kinnear Road, Columbus, OH 43212"
  }

  @user_attrs %{
    email: "betterrx@test.com",
    password: "123456"
  }

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> Enum.into(@user_attrs)
      |> Accounts.create_user()

    user
  end

  def pharmacy_fixture(attrs \\ %{}) do
    {:ok, phamacy} =
      attrs
      |> Enum.into(@pharmacy_attrs)
      |> Accounts.create_pharmacy()

    pharmacy
  end

  describe "accounts_orders" do
    test "create_order/1 creates and order when user is a pharmacy" do
      assert {:ok, pharmacy} = Accounts.create_pharmacy(@pharmacy_attributes)
      # assert {:ok, user} = Accounts.create_user(@user_attrs)
    end
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
end
