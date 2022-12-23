defmodule SnakeWeb.SnakeChannel do
  @moduledoc """
  Main snake channel for handling updates with the page.
  """
  use SnakeWeb, :channel

  alias Snake.EventHandler
  alias Snake.Handler

  @directions %{"up" => :up, "down" => :down, "left" => :left, "right" => :right}

  @impl true
  def join("snake", _params, socket) do
    {status, score, high_score} = EventHandler.subscribe()
    {:ok, %{status: status, score: score, high_score: high_score}, socket}
  end

  @impl true
  def handle_in("new_direction", %{"direction" => direction}, socket) do
    case Map.fetch(@directions, direction) do
      {:ok, direction} ->
        Handler.turn(socket.assigns.user_id, direction)
        {:reply, :ok, socket}

      :error ->
        {:reply, :error, socket}
    end
  end

  @impl true
  def handle_in("start", _params, socket) do
    Handler.start_game(socket.assigns.user_id)
    {:reply, {:ok, %{status: :started}}, socket}
  end

  @impl true
  def handle_in(_event, _params, socket) do
    {:reply, :ok, socket}
  end

  @impl true
  def handle_info({:status, status}, socket) do
    broadcast(socket, "new_status", %{status: status})
    {:noreply, socket}
  end

  @impl true
  def handle_info({:update_score, score, high_score}, socket) do
    broadcast(socket, "update_score", %{score: score, high_score: high_score})
    {:noreply, socket}
  end
end
