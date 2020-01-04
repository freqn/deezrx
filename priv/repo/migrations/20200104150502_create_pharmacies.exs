defmodule Deezrx.Repo.Migrations.CreatePharmacies do
  use Ecto.Migration

  def change do
    create table(:pharmacies) do
      add :name, :string
      add :address, :string
      add :courier_id, :integer

      timestamps()
    end

  end
end
