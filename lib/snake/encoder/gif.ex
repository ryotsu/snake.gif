defmodule Snake.Encoder.GIF do
  @moduledoc """
  GIF89a Encoder
  """

  use Rustler, otp_app: :snake, crate: :snake_gif

  @dialyzer {:nowarn_function, __init__: 0}

  @spec new_game() :: {:ok, reference, binary}
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
    <<
      width::little-16,
      height::little-16,
      # Global colour table table flag
      1::1,
      # Colour resolution
      resolution::3,
      # Sort flag
      0::1,
      # Size of global colour table
      resolution::3,
      # Background colour index
      0,
      # Pixel aspect ratio
      0
    >>
  end

  @spec color_table :: binary
  def color_table do
    <<
      # Grey
      0x40,
      0x40,
      0x40,
      # White
      0xFF,
      0xFF,
      0xFF,
      # Red
      0xFF,
      0x00,
      0x00,
      # Black again
      0x00,
      0x00,
      0x00
    >>
  end

  @spec graphic_control_ext(integer, integer) :: binary
  def graphic_control_ext(disposal \\ 0, delay \\ 0) do
    <<
      # Extension introducer
      0x21,
      # Graphic control label
      0xF9,
      # Length of block
      0x04,
      # Reserved for future use
      0::3,
      # Disposal method
      disposal::3,
      # User input flag
      0::1,
      # Transparent colour flag
      0::1,
      # Animation delay as a multiples of 10ms
      delay::little-16,
      # Transparent colour index
      0,
      # Block terminator
      0
    >>
  end

  @spec image_descriptor(integer, integer, integer, integer) :: binary
  def image_descriptor(left \\ 0, top \\ 0, width, height) do
    <<
      # Image seperator
      0x2C,
      left::little-16,
      top::little-16,
      width::little-16,
      height::little-16,
      # Local colour table flag
      0::1,
      # Interlace flag
      0::1,
      # Sort flag
      0::1,
      # Reserved for future use
      0::2,
      # Size of local colour table
      0::3
    >>
  end

  @spec application_extension(integer) :: binary
  def application_extension(loop) do
    <<
      # Extension introducer
      0x21,
      # Application extension label
      0xFF,
      # Length of application block
      11,
      # Extension name
      "NETSCAPE2.0",
      # Length of data sub block
      3,
      1,
      # Loop counter
      loop::little-16,
      # Data sub block terminator
      0
    >>
  end
end
