defmodule SnakeWeb.PageController do
  use SnakeWeb, :controller

  alias Snake.Handler

  def index(conn, _params) do
    user_id = :crypto.strong_rand_bytes(16) |> Base.encode64()

    conn
    |> assign(:user_id, user_id)
    |> render("index.html")
  end

  def gif(conn, _params) do
    conn =
      conn
      |> put_resp_content_type("image/gif")
      |> put_resp_header("Cache-Control", "no-cache, no-store, no-transform")
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
