# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Deezrx.Repo.insert!(%Deezrx.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
defmodule Seed do
  alias Deezrx.{
    Repo,
    Accounts,
    Accounts.Courier,
    Accounts.Pharmacy,
    Accounts.Order,
    Accounts.User
  }

  def generate() do
    clean()
    seed_couriers()
    seed_pharmacies()
    seed_orders()
    seed_users()
  end

  defp clean() do
    Repo.delete_all(Order)
    Repo.delete_all(Courier)
    Repo.delete_all(Pharmacy)
    Repo.delete_all(User)
    Repo.query("ALTER SEQUENCE pharmacies_id_seq RESTART")
    Repo.query("ALTER SEQUENCE couriers_id_seq RESTART")
    Repo.query("ALTER SEQUENCE orders_id_seq RESTART")
    Repo.query("ALTER SEQUENCE users_id_seq RESTART")
  end

  defp seed_couriers() do
    c1 = %{
      name: "Same Day Delivery",
      address: "900 Trenton Lane, Trenton, NJ 08536"
    }

    c2 = %{
      name: "Previous Day Delivery",
      address: "7433 LA Ct, Los Angeles, CA 90056"
    }

    gen_courier(c1)
    gen_courier(c2)
  end

  defp seed_pharmacies() do
    courier1 = Repo.get_by!(Courier, name: "Same Day Delivery")
    courier2 = Repo.get_by!(Courier, name: "Previous Day Delivery")

    p1 = %{
      name: "BetterRx",
      address: "1275 Kinnear Road, Columbus, OH 43212",
      courier_id: courier1.id
    }

    p2 = %{
      name: "BestRx",
      address: "123 Austin St, Austin, TX 78702",
      courier_id: courier1.id
    }

    p3 = %{
      name: "Drugs R Us",
      address: "4925 LA Ave, Los Angeles, CA 90056",
      courier_id: courier2.id
    }

    gen_pharm(p1)
    gen_pharm(p2)
    gen_pharm(p3)
  end

  defp seed_orders() do
    pharmacy1 = Repo.get_by!(Pharmacy, name: "BetterRx")
    pharmacy2 = Repo.get_by!(Pharmacy, name: "BestRx")
    pharmacy3 = Repo.get_by!(Pharmacy, name: "Drugs R Us")

    o1 = %{
      patient_first_name: "Carl",
      patient_last_name: "Weathers",
      patient_address: "60 Main, Testville, OH, 45632",
      description: "Prilosec for 3 months",
      pickup_date: Date.utc_today(),
      pickup_time: ~T[19:39:31.056226],
      pharmacy_id: pharmacy1.id
    }

    o2 = %{
      patient_first_name: "Joe",
      patient_last_name: "Weller",
      patient_address: "58 3rd St, Columbus, OH, 45632",
      description: "Xanax for 3 months",
      pickup_date: ~D[2020-01-22],
      pickup_time: ~T[19:39:31.056226],
      pharmacy_id: pharmacy1.id
    }

    o3 = %{
      patient_first_name: "Sarah",
      patient_last_name: "Rodriquez",
      patient_address: "3 Innovation Blvd, Lebanon, OH, 45236",
      description: "Oxy for 3 months",
      pickup_date: Date.utc_today(),
      pickup_time: ~T[09:39:31.056226],
      pharmacy_id: pharmacy2.id
    }

    o4 = %{
      patient_first_name: "Pablo",
      patient_last_name: "Escobar",
      patient_address: "666 South Ave, Bogota, KY, 43256",
      description: "ibuprofen 1600mg for 3 months",
      pickup_date: Date.utc_today(),
      pickup_time: ~T[19:39:31.056226],
      pharmacy_id: pharmacy3.id
    }

    gen_order(o1)
    gen_order(o2)
    gen_order(o3)
    gen_order(o4)
  end

  defp seed_users() do
    password = "password123"
    pharmacy1 = Repo.get_by!(Pharmacy, name: "BetterRx")
    pharmacy2 = Repo.get_by!(Pharmacy, name: "BestRx")
    pharmacy3 = Repo.get_by!(Pharmacy, name: "Drugs R Us")
    courier1 = Repo.get_by!(Courier, name: "Same Day Delivery")
    courier2 = Repo.get_by!(Courier, name: "Previous Day Delivery")

    p1 = %{
      email: "betterrx@test.com",
      password: password,
      org_id: pharmacy1.id,
      is_pharmacy: true
    }

    p2 = %{
      email: "bestrx@test.com",
      password: password,
      org_id: pharmacy2.id,
      is_pharmacy: true
    }

    p3 = %{
      email: "drugsrus@test.com",
      password: password,
      org_id: pharmacy3.id,
      is_pharmacy: true
    }

    c1 = %{
      email: "sameday@test.com",
      password: password,
      org_id: courier1.id,
      is_courier: true
    }

    c2 = %{
      email: "previousday@test.com",
      password: password,
      org_id: courier2.id,
      is_courier: true
    }

    gen_user(p1)
    gen_user(p2)
    gen_user(p3)
    gen_user(c1)
    gen_user(c2)
  end

  defp gen_courier(attrs) do
    Accounts.create_courier(attrs)
  end

  defp gen_pharm(attrs) do
    Accounts.create_pharmacy(attrs)
  end

  defp gen_order(attrs) do
    Accounts.create_order(attrs)
  end

  defp gen_user(attrs) do
    Accounts.create_user(attrs)
  end
end

Seed.generate()
