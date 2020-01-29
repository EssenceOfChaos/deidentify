defmodule DeidentifyWeb.Router do
  use DeidentifyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", DeidentifyWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", DeidentifyWeb do
    pipe_through :api
    resources "/records", RecordController, except: [:new, :edit]
  end
end
