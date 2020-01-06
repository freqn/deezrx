defmodule DeezrxWeb.Router do
  use DeezrxWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
    # plug(DeezrxWeb.Plugs.CurrentUser)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", DeezrxWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", OrderController, :index)
    resources("/orders", OrderController)
    resources("/sessions", SessionController, only: [:new, :create], singleton: true)
  end

  # Other scopes may use custom stacks.
  # scope "/api", DeezrxWeb do
  #   pipe_through :api
  # end
end
