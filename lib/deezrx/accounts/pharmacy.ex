defmodule Deezrx.Accounts.Pharmacy do
  use Ecto.Schema
  import Ecto.Changeset

  schema "pharmacies" do
    field(:address, :string)
    field(:name, :string)
    has_many(:orders, Deezrx.Accounts.Order)
    timestamps()
  end

  @doc false
  def changeset(pharmacy, attrs) do
    pharmacy
    |> cast(attrs, [:name, :address])
    |> validate_required([:name, :address])
  end
end
