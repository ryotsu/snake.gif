defmodule Snake.EventHandler do
  @moduledoc """
  Handles start and stop events
  """

  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def subscribe do
    GenServer.call(__MODULE__, :subscribe)
  end

  def set_status(status) do
    GenServer.cast(__MODULE__, {:set_status, status})
  end

  def init(:ok) do
    {:ok, %{clients: [], status: :started}}
  end

  def handle_call(:subscribe, {pid, _tag}, %{clients: clients} = state) do
    clients = [pid | clients]
    Process.monitor(pid)
    {:reply, state.status, %{state | clients: clients}}
  end

  def handle_cast({:set_status, status}, %{clients: []} = state) do
    {:noreply, %{state | status: status}}
  end

  def handle_cast({:set_status, status}, %{clients: clients} = state) do
    client = Enum.random(clients)
    send(client, {:status, status})
    {:noreply, %{state | status: status}}
  end

  def handle_info({:DOWN, _ref, :process, pid, _reason}, state) do
    clients = List.delete(state.clients, pid)
    {:noreply, %{state | clients: clients}}
  end
end
