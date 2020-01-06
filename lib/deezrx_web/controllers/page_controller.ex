defmodule DeezrxWeb.PageController do
  use DeezrxWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
