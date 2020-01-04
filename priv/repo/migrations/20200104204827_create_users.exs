defmodule Deezrx.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add(:email, :string)
      add(:password_hash, :string)
      add(:org_id, :string)
      add(:is_pharmacy, :boolean, default: false)
      add(:is_courier, :boolean, default: false)

      timestamps()
    end

    create(index(:users, :email, unique: true))
  end
end
