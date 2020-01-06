defmodule DeezrxWeb.SessionController do
  use DeezrxWeb, :controller
  alias Deezrx.Accounts
  alias DeezrxWeb.Plugs.CurrentUser

  def new(conn, _params) do
    render(conn, "new.html")
  end

  @spec create(Plug.Conn.t(), map) :: Plug.Conn.t()
  def create(conn, %{"credentials" => %{"email" => email, "password" => password}}) do
    # require IEx
    # IEx.pry()

    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome to Storex")
        |> CurrentUser.set(user)
        |> redirect(to: order_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "Unable to sign in")
        |> render("new.html")
    end
  end
end
