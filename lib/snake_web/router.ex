defmodule SnakeWeb.Router do
  use SnakeWeb, :router

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

  scope "/", SnakeWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/snake.gif", PageController, :gif
  end

  # Other scopes may use custom stacks.
  # scope "/api", SnakeWeb do
  #   pipe_through :api
  # end
end
