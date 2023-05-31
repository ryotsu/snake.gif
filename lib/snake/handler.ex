defmodule Snake.Handler do
  @moduledoc """
  Snake Handler

  Manages the snake game and produces the image to be sent to the clients
  """

  use GenServer

  alias Snake.Encoder, as: GIF
  alias Snake.EventHandler

  @doc """
  Stars the GenServer
  """
  @spec start_link(:ok) :: {:ok, pid}
  def start_link(:ok) do
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

  @impl true
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
       player_id: nil,
       direction: {nil, nil},
       high_score: 0,
       score: 0
     }}
  end

  @impl true
  def handle_call({:start, player_id}, _from, %{status: :initialized} = state) do
    EventHandler.set_status(:running)
    {:reply, :ok, %{state | status: :running, player_id: player_id}}
  end

  @impl true
  def handle_call({:start, player_id}, _from, %{status: :stopped} = state) do
    {buffer, frame} = new_game()
    state = %{state | score: 0}
    EventHandler.set_status(:running)
    EventHandler.update_score({state.score, state.high_score})
    {:reply, :ok, %{state | buffer: buffer, frame: frame, status: :running, player_id: player_id}}
  end

  @impl true
  def handle_call({:start, _}, _from, %{status: :running} = state) do
    {:reply, {:error, "Already started"}, state}
  end

  @impl true
  def handle_call(:subscribe, {pid, _tag}, %{clients: clients} = state) do
    ref = Process.monitor(pid)
    clients = Map.put(clients, pid, ref)
    {:reply, state.base <> state.frame, %{state | clients: clients}}
  end

  @impl true
  def handle_cast(
        {:turn, player_id, direction},
        %{player_id: player_id, direction: {nil, nil}} = state
      ) do
    {:noreply, %{state | direction: {direction, nil}}}
  end

  @impl true
  def handle_cast(
        {:turn, player_id, direction},
        %{player_id: player_id, direction: {queued_dir, nil}} = state
      ) do
    {:noreply, %{state | direction: {queued_dir, direction}}}
  end

  @impl true
  def handle_cast({:turn, _, _}, state) do
    {:noreply, state}
  end

  @impl true
  def handle_info(:next_frame, %{status: :running, direction: {first, second}} = state) do
    clients = Map.get(state, :clients)

    if first != nil, do: GIF.turn(state.buffer, first)
    {status, frame, score} = get_next_frame(state.buffer, state.frame)
    set_timer_and_send(clients, frame)

    score = max(state.score, score)
    high_score = max(state.high_score, score)
    if score != state.score, do: EventHandler.update_score({score, high_score})

    state = %{state | score: score, high_score: high_score}
    {:noreply, %{state | frame: frame, status: status, direction: {second, nil}}}
  end

  @impl true
  def handle_info(:next_frame, %{frame: frame, clients: clients} = state) do
    set_timer_and_send(clients, frame)
    {:noreply, state}
  end

  def handle_info({:DOWN, _ref, :process, pid, _reason}, %{clients: clients} = state) do
    {ref, clients} = Map.pop(clients, pid)
    Process.demonitor(ref)
    {:noreply, %{state | clients: clients}}
  end

  @spec get_next_frame(reference, binary) :: {:running | :stopped, binary, integer}
  defp get_next_frame(buffer, frame) do
    case GIF.next_frame(buffer) do
      {:ok, {image_data, score}} ->
        new_frame = make_frame(image_data)
        {:running, new_frame, score}

      {:error, _err} ->
        EventHandler.set_status(:stopped)
        {:stopped, frame, 0}
    end
  end

  @spec new_game :: {reference, binary}
  defp new_game do
    {buffer, image_data} = GIF.new_game()
    frame = make_frame(image_data)
    {buffer, frame}
  end

  @spec make_frame(binary) :: binary
  defp make_frame(image_data) do
    GIF.graphic_control_ext(1, 10) <> GIF.image_descriptor(128, 128) <> image_data
  end

  @spec set_timer_and_send(map, binary) :: :ok
  defp set_timer_and_send(clients, frame) do
    Process.send_after(self(), :next_frame, 100)

    for client <- Map.keys(clients) do
      send(client, {:image, frame})
    end

    :ok
  end
end
