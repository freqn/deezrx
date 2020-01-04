defmodule Deezrx.Accounts.Courier do
  use Ecto.Schema
  import Ecto.Changeset


  schema "couriers" do
    field :address, :string
    field :name, :string

    timestamps()
  end

  @doc false
  def changeset(courier, attrs) do
    courier
    |> cast(attrs, [:name, :address])
    |> validate_required([:name, :address])
  end
end
