defmodule Deezrx.Repo.Migrations.CreateCouriers do
  use Ecto.Migration

  def change do
    create table(:couriers) do
      add(:name, :string)
      add(:address, :string)

      timestamps()
    end
  end
end
