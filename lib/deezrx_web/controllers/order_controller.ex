defmodule DeezrxWeb.OrderController do
  use DeezrxWeb, :controller

  alias Deezrx.Accounts

  def index(conn, _params) do
    render(conn, "index.html", orders: Accounts.list_orders())
  end
end
