defmodule Deezrx.Accounts.PharmacyCourier do
  use Ecto.Schema
  import Ecto.Changeset


  schema "pharmacy_couriers" do
    field :courier_id, :integer
    field :pharmacy_id, :integer

    timestamps()
  end

  @doc false
  def changeset(pharmacy_courier, attrs) do
    pharmacy_courier
    |> cast(attrs, [:pharmacy_id, :courier_id])
    |> validate_required([:pharmacy_id, :courier_id])
  end
end
