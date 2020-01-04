defmodule Deezrx.AccountsTest do
  use Deezrx.DataCase

  alias Deezrx.Accounts

  describe "couriers" do
    alias Deezrx.Accounts.Courier

    @valid_attrs %{address: "some address", name: "some name"}
    @update_attrs %{address: "some updated address", name: "some updated name"}
    @invalid_attrs %{address: nil, name: nil}

    def courier_fixture(attrs \\ %{}) do
      {:ok, courier} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_courier()

      courier
    end

    test "list_couriers/0 returns all couriers" do
      courier = courier_fixture()
      assert Accounts.list_couriers() == [courier]
    end

    test "get_courier!/1 returns the courier with given id" do
      courier = courier_fixture()
      assert Accounts.get_courier!(courier.id) == courier
    end

    test "create_courier/1 with valid data creates a courier" do
      assert {:ok, %Courier{} = courier} = Accounts.create_courier(@valid_attrs)
      assert courier.address == "some address"
      assert courier.name == "some name"
    end

    test "create_courier/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_courier(@invalid_attrs)
    end

    test "update_courier/2 with valid data updates the courier" do
      courier = courier_fixture()
      assert {:ok, courier} = Accounts.update_courier(courier, @update_attrs)
      assert %Courier{} = courier
      assert courier.address == "some updated address"
      assert courier.name == "some updated name"
    end

    test "update_courier/2 with invalid data returns error changeset" do
      courier = courier_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_courier(courier, @invalid_attrs)
      assert courier == Accounts.get_courier!(courier.id)
    end

    test "delete_courier/1 deletes the courier" do
      courier = courier_fixture()
      assert {:ok, %Courier{}} = Accounts.delete_courier(courier)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_courier!(courier.id) end
    end

    test "change_courier/1 returns a courier changeset" do
      courier = courier_fixture()
      assert %Ecto.Changeset{} = Accounts.change_courier(courier)
    end
  end
end
