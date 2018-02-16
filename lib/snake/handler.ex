defmodule Snake.Handler do
  @moduledoc """
  Snake Handler

  Manages the snake game and produces the image to be sent to the clients
  """

  use GenServer

  alias Snake.Encoder.GIF
  alias Snake.EventHandler

  @doc """
  Stars the GenServer
  """
  @spec start_link :: {:ok, pid}
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @doc """
  Starts the snake game for the user and starts sending frames to clients
  """
  @spec start_game(String.t()) :: :ok
  def start_game(player_id) do
    GenServer.call(__MODULE__, {:start, player_id})
  end

  @doc """
  Subscribe to the GenServer for receiving the gif image
  """
  @spec subscribe :: binary
  def subscribe do
    GenServer.call(__MODULE__, :subscribe)
  end

  @doc """
  Turns the snake in the given direction for the player
  """
  @spec turn(String.t(), :up | :down | :left | :right) :: :ok
  def turn(player_id, direction) do
    GenServer.cast(__MODULE__, {:turn, player_id, direction})
  end

  #################################### Callbacks ####################################

  @doc """
  Initializes the GenServer with GIF base headers and starts the new_game
  """
  def init(:ok) do
    base =
      "GIF89a" <>
        GIF.screen_descriptor(128, 128, 1) <> GIF.color_table() <> GIF.application_extension(1)

    {buffer, frame} = new_game()
    EventHandler.set_status(:stopped)
    Process.send_after(self(), :next_frame, 100)

    {:ok,
     %{
       base: base,
       frame: frame,
       clients: %{},
       buffer: buffer,
       status: :initialized,
       player_id: nil
     }}
  end

  @doc """
  Starts the game if no game is running. Returns an error otherwise
  """
  def handle_call({:start, player_id}, _from, %{status: :initialized} = state) do
    EventHandler.set_status(:started)
    {:reply, :ok, %{state | status: :started, player_id: player_id}}
  end

  def handle_call({:start, player_id}, _from, %{status: :stopped} = state) do
    {buffer, frame} = new_game()
    EventHandler.set_status(:started)
    {:reply, :ok, %{state | buffer: buffer, frame: frame, status: :started, player_id: player_id}}
  end

  def handle_call({:start, _}, _from, %{status: :started} = state) do
    {:reply, {:error, "Already started"}, state}
  end

  @doc """
  Subscribes the caller by adding its pid to the list of clients and monitoring it
  """
  def handle_call(:subscribe, {pid, _tag}, %{clients: clients} = state) do
    ref = Process.monitor(pid)
    clients = Map.put(clients, pid, ref)
    {:reply, state.base <> state.frame, %{state | clients: clients}}
  end

  @doc """
  Turns the snake in the given direction if the player ids match
  """
  def handle_cast({:turn, player_id, direction}, %{player_id: player_id} = state) do
    GIF.turn(state.buffer, direction)
    {:noreply, state}
  end

  def handle_cast({:turn, _, _}, state) do
    {:noreply, state}
  end

  @doc """
  Gets the next frame of the gif image from the nif and sends it to all the clients.
  """
  def handle_info(:next_frame, %{status: :started, clients: clients} = state) do
    {status, frame} = get_next_frame(state.buffer, state.frame)
    set_timer_and_send(clients, frame)
    {:noreply, %{state | frame: frame, status: status}}
  end

  def handle_info(:next_frame, %{frame: frame, clients: clients} = state) do
    set_timer_and_send(clients, frame)
    {:noreply, state}
  end

  @doc """
  Unsubscribes the client when the client process dies
  """
  def handle_info({:DOWN, _ref, :process, pid, _reason}, %{clients: clients} = state) do
    {ref, clients} = Map.pop(clients, pid)
    Process.demonitor(ref)
    {:noreply, %{state | clients: clients}}
  end

  @spec get_next_frame(reference, binary) :: {:started, binary} | {:stopped, binary}
  defp get_next_frame(buffer, frame) do
    case GIF.next_frame(buffer) do
      {:ok, image_data} ->
        new_frame = make_frame(image_data)
        {:started, new_frame}

      {:error, _err} ->
        EventHandler.set_status(:stopped)
        {:stopped, frame}
    end
  end

  @spec new_game :: {reference, binary}
  defp new_game do
    {:ok, buffer, image_data} = GIF.new_game()
    frame = make_frame(image_data)
    {buffer, frame}
  end

  @spec make_frame(binary) :: binary
  defp make_frame(image_data) do
    GIF.graphic_control_ext(1, 10) <> GIF.image_descriptor(128, 128) <> image_data
  end

  @spec set_timer_and_send([pid], binary) :: :ok
  defp set_timer_and_send(clients, frame) do
    Process.send_after(self(), :next_frame, 100)

    for client <- Map.keys(clients) do
      send(client, {:image, frame})
    end

    :ok
  end
end
