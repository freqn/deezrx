defmodule DeezrxWeb.OrderController do
  require IEx
  use DeezrxWeb, :controller
  alias Deezrx.Accounts
  alias DeezrxWeb.Plugs.CurrentUser

  def index(conn, _params) do
    user = conn |> CurrentUser.get()

    cond do
      CurrentUser.is_pharmacy?(conn) ->
        render(conn, "index.html",
          orders: user.org_id |> Accounts.list_orders_by_pharmacy(),
          current_user: user
        )

      CurrentUser.is_courier?(conn) ->
        render(conn, "index.html",
          orders: user.org_id |> Accounts.list_orders_by_courier(),
          current_user: user
        )

      CurrentUser.is_admin?(conn) ->
        render(conn, "index.html",
          orders: Accounts.list_orders(),
          current_user: user
        )

      true ->
        conn |> redirect(to: session_path(conn, :new))
    end
  end

  def show(conn, %{"id" => order_id}) do
    render(conn, "show.html", order: Accounts.get_order!(order_id))
  end

  def new(conn, _params) do
    changeset = Accounts.change_order()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"order" => order_params}) do
    case Accounts.create_order(order_params) do
      {:ok, order} ->
        conn
        |> put_flash(:info, "Order created")
        |> render("index.html", orders: Accounts.list_orders())

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id" => order_id}) do
    order = Accounts.get_order!(order_id)
    changeset = Accounts.change_order(order)

    render(conn, "edit.html", changeset: changeset, order: order)
  end

  def update(conn, %{"id" => order_id, "order" => order_params}) do
    order = Accounts.get_order!(order_id)

    case Accounts.update_order(order, order_params) do
      {:ok, order} ->
        conn
        |> put_flash(:info, "Book updated")
        |> redirect(to: "/")

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => order_id}) do
    order = Accounts.get_order!(order_id)
    Accounts.delete_order(order)

    conn
    |> put_flash(:info, "#{order.title} deleted")
    |> redirect(to: "/")
  end
end
