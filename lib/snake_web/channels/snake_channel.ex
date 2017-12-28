defmodule SnakeWeb.SnakeChannel do
  use SnakeWeb, :channel

  alias Snake.EventHandler
  alias Snake.Handler

  @directions %{"up" => :up, "down" => :down, "left" => :left, "right" => :right}

  def join("snake", _params, socket) do
    status = EventHandler.subscribe()
    {:ok, %{status: status}, socket}
  end

  def handle_in("new_direction", %{"direction" => direction}, socket) do
    case Map.fetch(@directions, direction) do
      {:ok, direction} ->
        Handler.turn(socket.assigns.user_id, direction)
        {:reply, :ok, socket}

      :error ->
        {:reply, :error, socket}
    end
  end

  def handle_in("start", _params, socket) do
    Handler.start_game(socket.assigns.user_id)
    {:reply, {:ok, %{status: :started}}, socket}
  end

  def handle_in(_event, _params, socket) do
    {:reply, :ok, socket}
  end

  def handle_info({:status, status}, socket) do
    broadcast(socket, "new_status", %{status: status})
    {:noreply, socket}
  end
end
