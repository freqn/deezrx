defmodule DeezrxWeb.OrderController do
  use DeezrxWeb, :controller
  alias Deezrx.Accounts
  alias DeezrxWeb.Plugs.CurrentUser

  @auth_err "Your account is not authorized to perform this action."

  def index(conn, _params) do
    user = conn |> CurrentUser.get()

    cond do
      conn |> pharma_user?(user) ->
        render(conn, "index.html",
          orders: user.org_id |> Accounts.list_orders_by_pharmacy(),
          user: user,
          org: Accounts.get_pharmacy!(user.org_id).name
        )

      conn |> courier_user?(user) ->
        render(conn, "index.html",
          orders: user.org_id |> Accounts.list_orders_by_courier(),
          user: user,
          org: Accounts.get_courier!(user.org_id).name
        )

      conn |> admin_user?(user) ->
        render(conn, "index.html",
          orders: Accounts.list_orders(),
          user: user,
          org: "Administrator"
        )

      true ->
        conn
        |> put_flash(:error, @auth_err)
        |> redirect(to: session_path(conn, :new))
    end
  end

  def show(conn, %{"id" => order_id}) do
    user = conn |> CurrentUser.get()

    cond do
      conn |> pharma_user?(user) ->
        order = Accounts.get_order!(order_id)

        if user.org_id == order.pharmacy_id do
          render(conn, "show.html", order: order, user: user)
        else
          handle_exception(conn)
        end

      conn |> admin_user?(user) ->
        render(conn, "show.html", order: Accounts.get_order!(order_id), user: user)

      true ->
        conn |> handle_exception
    end
  end

  def new(conn, _params) do
    user = conn |> CurrentUser.get()

    cond do
      conn |> pharma_user?(user) ->
        changeset = Accounts.change_order()
        render(conn, "new.html", changeset: changeset, pharm_id: user.org_id)

      true ->
        conn |> handle_exception()
    end
  end

  def create(conn, %{"order" => order_params}) do
    user = conn |> CurrentUser.get()

    cond do
      conn |> pharma_user?(user) ->
        pharmacy = Accounts.get_pharmacy!(user.org_id)

        params =
          order_params
          |> Map.put("courier_id", Accounts.get_pharm_courier!(user.org_id))

        params = params |> Map.put("pharmacy_id", user.org_id)
        params = params |> Map.put("pharmacy_name", pharmacy.name)

        case Accounts.create_order(params) do
          {:ok, _order} ->
            conn
            |> put_flash(:info, "Order created")
            |> redirect(to: "/")

          {:error, changeset} ->
            render(conn, "new.html", changeset: changeset)
        end

      true ->
        conn |> handle_exception
    end
  end

  def edit(conn, %{"id" => order_id}) do
    user = conn |> CurrentUser.get()

    cond do
      conn |> pharma_user?(user) ->
        order = Accounts.get_order!(order_id)
        changeset = Accounts.change_order(order)

        render(conn, "edit.html", changeset: changeset, order: order)

      true ->
        handle_exception(conn)
    end
  end

  def update(conn, %{"id" => order_id, "order" => order_params}) do
    user = conn |> CurrentUser.get()

    cond do
      conn |> pharma_user?(user) ->
        order = Accounts.get_order!(order_id)

        case Accounts.update_order(order, order_params) do
          {:ok, _order} ->
            conn
            |> put_flash(:info, "Order updated")
            |> redirect(to: "/")

          {:error, changeset} ->
            render(conn, "edit.html", changeset: changeset)
        end

      true ->
        handle_exception(conn)
    end
  end

  def cancel(conn, %{"id" => id}) do
    order = Accounts.get_order!(id)

    case Accounts.update_order(order, %{active: false}) do
      {:ok, _order} ->
        conn
        |> put_flash(:info, "Order Canceled")
        |> redirect(to: "/")

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def deliver(conn, %{"id" => id}) do
    user = conn |> CurrentUser.get()

    cond do
      conn |> courier_user?(user) ->
        order = Accounts.get_order!(id)

        case Accounts.update_order(order, %{delivered: true}) do
          {:ok, _order} ->
            conn
            |> put_flash(:info, "Delivered")
            |> redirect(to: "/")

          {:error, changeset} ->
            render(conn, "edit.html", changeset: changeset)
        end

      true ->
        conn
        |> put_flash(:error, @auth_err)
        |> redirect(to: session_path(conn, :new))
    end
  end

  def mark_undeliverable(conn, %{"id" => id}) do
    order = Accounts.get_order!(id)

    case Accounts.update_order(order, %{undeliverable: true}) do
      {:ok, _order} ->
        conn
        |> put_flash(:info, "Marked as Undeliverable")
        |> redirect(to: "/")

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def pharma_user?(conn, user) do
    user && CurrentUser.is_pharmacy?(conn)
  end

  def courier_user?(conn, user) do
    user && CurrentUser.is_courier?(conn)
  end

  def admin_user?(conn, user) do
    user && CurrentUser.is_admin?(conn)
  end

  def handle_exception(conn) do
    conn
    |> put_flash(:error, @auth_err)
    |> redirect(to: "/")
  end
end
