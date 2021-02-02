defmodule Snake.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      SnakeWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Snake.PubSub},
      # Start the Endpoint (http/https)
      SnakeWeb.Endpoint,
      # Start a worker by calling: Snake.Worker.start_link(arg)
      # {Snake.Worker, arg}
      {Snake.EventHandler, :ok},
      {Snake.Handler, :ok}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Snake.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    SnakeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
