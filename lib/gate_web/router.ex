defmodule GateWeb.Router do
  use GateWeb, :router

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

  scope "/", GateWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/application", GateWeb do
    # Use the default browser stack
    pipe_through(:api)


    get("/status", StatusController, :status)
    get("/lock", ProjectController, :lock)
    get("/unlock", ProjectController, :unlock)
  end

  # Other scopes may use custom stacks.
  # scope "/api", GateWeb do
  #   pipe_through :api
  # end
end
