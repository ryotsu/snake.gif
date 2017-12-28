defmodule SnakeWeb.Router do
  use SnakeWeb, :router

  pipeline :browser do
    plug(:accepts, ["html"])
    plug(:fetch_session)
    plug(:fetch_flash)
    plug(:protect_from_forgery)
    plug(:put_secure_browser_headers)
  end

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", SnakeWeb do
    # Use the default browser stack
    pipe_through(:browser)

    get("/", SnakeController, :index)
    get("/snake.gif", SnakeController, :gif)
  end
end
