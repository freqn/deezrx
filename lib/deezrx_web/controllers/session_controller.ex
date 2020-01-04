defmodule DeezrxWeb.SessionController do
  use DeezrxWeb, :controller
  alias Deezrx.Accounts
  # alias DeezrxWeb.Plugs.CurrentUser

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"credentials" => %{"email" => email, "password" => password}}) do
    case Accounts.authenticate_user(email, password) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome to Storex")
        # |> CurrentUser.set(user)
        |> redirect(to: order_path(conn, :index))

      {:error, _} ->
        conn
        |> put_flash(:error, "Unable to sign in")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> CurrentUser.forget()
    |> redirect(to: order_path(conn, :index))
  end
end
