defmodule SnakeWeb.PageController do
  use SnakeWeb, :controller

  def home(conn, _params) do
    {status, score, high_score} = Snake.Handler.get_info()
    user_token = :crypto.strong_rand_bytes(32) |> Base.encode64()

    conn
    |> assign(:user_token, user_token)
    |> assign(:status, status)
    |> assign(:score, score)
    |> assign(:high_score, high_score)
    |> render(:home)
  end

  def gif(conn, _params) do
    conn =
      conn
      |> put_resp_content_type("image/gif")
      |> put_resp_header("Cache-Control", "no-cache, no-store, no-transform")
      |> send_chunked(200)

    data = Snake.Handler.subscribe()
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
