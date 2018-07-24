defmodule PingyWeb.Router do
  use PingyWeb, :router

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

  scope "/", PingyWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index

    resources "/servers", ServerController
    post "/servers/:id/check", ServerController, :check
  end

  # Other scopes may use custom stacks.
  # scope "/api", PingyWeb do
  #   pipe_through :api
  # end
end
