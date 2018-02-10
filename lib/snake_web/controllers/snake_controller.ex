defmodule SnakeWeb.SnakeController do
  use SnakeWeb, :controller

  alias Snake.Handler

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def gif(conn, _params) do
    conn =
      conn
      |> put_resp_content_type("image/gif")
      |> send_chunked(200)

    data = Handler.subscribe()
    {:ok, conn} = chunk(conn, data)
    next_frame(conn)
  end

  defp next_frame(conn) do
    receive do
      {:image, data} ->
        case chunk(conn, data) do
          {:ok, conn} -> next_frame(conn)
          {:error, :closed} -> conn
        end
    end
  end
end
