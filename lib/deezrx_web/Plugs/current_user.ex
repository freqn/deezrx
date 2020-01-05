defmodule DeezrxWeb.Plugs.CurrentUser do
  import Plug.Conn
  alias Deezrx.Accounts

  @session_name :user_id
  @assign_name :current_user

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, @session_name)

    cond do
      user = user_id && Accounts.get_user!(user_id) -> assign_user(conn, user)
      true -> assign_user(conn, nil)
    end
  end

  def assign_user(conn, user) do
    conn
    |> assign(@assign_name, user)
    |> assign(:is_pharmacy, is_pharmacy?(user))
  end

  def set(conn, user) do
    conn
    |> put_session(@session_name, user.id)
    |> assign_user(user)
  end

  def get(conn), do: conn.assigns[@assign_name]

  def is_pharmacy?(%Plug.Conn{} = conn) do
    user = get(conn)
    is_pharmacy?(user)
  end

  def is_pharmacy?(user) do
    user && user.is_pharmacy
  end

  def forget(conn) do
    delete_session(conn, @session_name)
  end
end
