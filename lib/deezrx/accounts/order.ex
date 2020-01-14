defmodule Deezrx.Accounts.Order do
  use Ecto.Schema
  import Ecto.Changeset
  alias Deezrx.Accounts

  schema "orders" do
    field(:patient_first_name, :string)
    field(:patient_last_name, :string)
    field(:patient_address, :string)
    field(:prescription, :string)
    belongs_to(:pharmacy, Accounts.Pharmacy)
    belongs_to(:courier, Accounts.Courier)
    field(:pickup_date, :date)
    field(:pickup_time, :time)
    field(:pharmacy_name, :string)
    field(:delivered, :boolean, default: false)
    field(:undeliverable, :boolean, default: false)
    field(:active, :boolean, default: true)

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [
      :patient_first_name,
      :patient_last_name,
      :patient_address,
      :prescription,
      :pickup_date,
      :pickup_time,
      :pharmacy_name,
      :pharmacy_id,
      :courier_id,
      :delivered,
      :undeliverable,
      :active
    ])
    |> validate_required([
      :patient_first_name,
      :patient_last_name,
      :patient_address,
      :pickup_date,
      :pickup_time
    ])
  end
end
