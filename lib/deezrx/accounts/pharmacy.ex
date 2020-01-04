defmodule Deezrx.Accounts.Pharmacy do
  use Ecto.Schema
  import Ecto.Changeset


  schema "pharmacies" do
    field :address, :string
    field :courier_id, :integer
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(pharmacy, attrs) do
    pharmacy
    |> cast(attrs, [:name, :address, :courier_id])
    |> validate_required([:name, :address, :courier_id])
  end
end
