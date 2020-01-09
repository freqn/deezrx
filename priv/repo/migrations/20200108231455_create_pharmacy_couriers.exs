defmodule Deezrx.Repo.Migrations.CreatePharmacyCouriers do
  use Ecto.Migration

  def change do
    create table(:pharmacy_couriers) do
      add :pharmacy_id, :integer
      add :courier_id, :integer

      timestamps()
    end

  end
end
