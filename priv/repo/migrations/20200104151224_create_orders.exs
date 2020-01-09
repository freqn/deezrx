defmodule Deezrx.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add(:patient_first_name, :string)
      add(:patient_last_name, :string)
      add(:patient_address, :string)
      add(:prescription, :string)
      add(:pickup_date, :date)
      add(:pickup_time, :time)
      add(:pharmacy_name, :string)
      add(:pharmacy_id, references(:pharmacies))
      add(:courier_id, references(:couriers))
      add(:delivered, :boolean, default: false)
      add(:undeliverable, :boolean, default: false)
      add(:active, :boolean, default: true)
      timestamps()
    end
  end
end
