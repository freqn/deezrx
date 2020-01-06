defmodule Deezrx.Accounts.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field(:description, :string)
    field(:patient_address, :string)
    field(:patient_first_name, :string)
    field(:patient_last_name, :string)
    field(:pharmacy_id, :integer)
    field(:pickup_date, :string)
    field(:pickup_time, :string)
    field(:delivered, :boolean, default: false)

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [
      :patient_first_name,
      :patient_last_name,
      :patient_address,
      :description,
      :pickup_date,
      :pickup_time,
      :pharmacy_id,
      :delivered
    ])
    |> validate_required([
      :patient_first_name,
      :patient_last_name,
      :patient_address,
      :description,
      :pickup_date,
      :pickup_time
    ])
  end
end
