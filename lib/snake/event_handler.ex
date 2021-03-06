defmodule Snake.EventHandler do
  @moduledoc """
  Handles start and stop events
  """

  use GenServer

  def start_link(:ok) do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def subscribe do
    GenServer.call(__MODULE__, :subscribe)
  end

  def set_status(status) do
    GenServer.cast(__MODULE__, {:set_status, status})
  end

  def init(:ok) do
    {:ok, %{clients: %{}, status: :started}}
  end

  def handle_call(:subscribe, {pid, _tag}, %{clients: clients} = state) do
    ref = Process.monitor(pid)
    clients = Map.put(clients, pid, ref)
    {:reply, state.status, %{state | clients: clients}}
  end

  def handle_cast({:set_status, status}, %{clients: clients} = state) when clients == %{} do
    {:noreply, %{state | status: status}}
  end

  def handle_cast({:set_status, status}, %{clients: clients} = state) do
    client = Enum.random(Map.keys(clients))
    send(client, {:status, status})
    {:noreply, %{state | status: status}}
  end

  def handle_info({:DOWN, _ref, :process, pid, _reason}, %{clients: clients} = state) do
    {ref, clients} = Map.pop(clients, pid)
    Process.demonitor(ref)
    {:noreply, %{state | clients: clients}}
  end
end
