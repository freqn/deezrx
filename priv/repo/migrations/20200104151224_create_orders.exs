defmodule Deezrx.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add(:patient_first_name, :string)
      add(:patient_last_name, :string)
      add(:patient_address, :string)
      add(:prescription, :string)
      add(:pickup_date, :string)
      add(:pickup_time, :string)
      add(:pharmacy_id, references(:pharmacies))
      add(:courier_id, references(:couriers))
      add(:delivered, :boolean, default: false)
      timestamps()
    end
  end
end
