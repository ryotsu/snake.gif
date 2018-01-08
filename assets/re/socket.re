let connect = user_id =>
  Phx.initSocket(
    "/socket",
    ~opts={
      "params": {
        "user_id": user_id
      },
      "logger": (kind, msg, data) => Js.log2(kind ++ ": " ++ msg, data)
    }
  )
  |> Phx.connectSocket
  |> Phx.putOnClose(() => Js.log("Socket closed"));
