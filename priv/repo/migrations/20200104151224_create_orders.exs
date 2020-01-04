defmodule Deezrx.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add :patient_first_name, :string
      add :patient_last_name, :string
      add :patient_address, :string
      add :description, :string
      add :pickup_date, :date
      add :pickup_time, :time
      add :pharmacy_id, :integer

      timestamps()
    end

  end
end
