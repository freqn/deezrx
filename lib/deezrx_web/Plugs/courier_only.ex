defmodule DeezrxWeb.Plugs.CourierOnly do
  import Plug.Conn
  alias DeezrxWeb.Plugs
  def init(opts), do: opts

  def call(conn, _opts) do
    if Plugs.CurrentUser.is_courier?(conn) do
      conn
    else
      conn
      |> put_resp_content_type("text/plain")
      |> send_resp(:forbidden, "forbidden")
      |> halt()
    end
  end
end