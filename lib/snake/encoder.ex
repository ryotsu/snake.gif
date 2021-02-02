defmodule Snake.Encoder do
  @moduledoc """
  Snake encoder as a rust nif
  """

  use Rustler, otp_app: :snake, crate: :snake

  @dialyzer {:nowarn_function, __init__: 0}

  @spec new_game() :: {reference, binary}
  def new_game(), do: err()

  @spec next_frame(reference) :: {:ok, binary} | {:error, binary}
  def next_frame(_buffer), do: err()

  @spec turn(reference, :up | :down | :left | :right) :: :ok
  def turn(_buffer, _direction), do: err()

  defp err do
    :erlang.nif_error(:nif_not_loaded)
  end

  @spec screen_descriptor(integer, integer, integer) :: binary
  def screen_descriptor(width, height, resolution) do
    <<width :: little-16,
      height :: little-16,
      1 :: 1,          # Global colour table table flag
      resolution :: 3, # Colour resolution
      0 :: 1,          # Sort flag
      resolution :: 3, # Size of global colour table
      0,               # Background colour index
      0,               # Pixel aspect ratio
    >>
  end

  @spec color_table :: binary
  def color_table do
    <<0x40, 0x40, 0x40, # Grey
      0xFF, 0xFF, 0xFF, # White
      0xFF, 0x00, 0x00, # Red
      0x00, 0x00, 0x00, # Black
    >>
  end

  @spec graphic_control_ext(integer, integer) :: binary
  def graphic_control_ext(disposal \\ 0, delay \\ 0) do
    <<0x21,               # Extension introducer
      0xF9,               # Graphic control label
      0x04,               # Length of block
      0 :: 3,             # Reserved for future use
      disposal :: 3,      # Disposal method
      0 :: 1,             # User input flag
      0 :: 1,             # Transparent colour flag
      delay :: little-16, # Animation delay as a multiples of 10ms
      0,                  # Transparent colour index
      0,                  # Block terminator
    >>
  end

  @spec image_descriptor(integer, integer, integer, integer) :: binary
  def image_descriptor(left \\ 0, top \\ 0, width, height) do
    <<0x2C,               # Image seperator
      left :: little-16,
      top :: little-16,
      width :: little-16,
      height :: little-16,
      0 :: 1,             # Local colour table flag
      0 :: 1,             # Interlace flag
      0 :: 1,             # Sort flag
      0 :: 2,             # Reserved for future use
      0 :: 3,             # Size of local colour table
    >>
  end

  @spec application_extension(integer) :: binary
  def application_extension(loop) do
    <<0x21,                # Extension introducer
      0xFF,                # Application extension label
      11,                  # Length of application block
      "NETSCAPE2.0",       # Extension name
      3,                   # Length of data sub block
      1,
      loop :: little-16,   # Loop counter
      0,                   # Data sub block terminator
    >>
  end
end
