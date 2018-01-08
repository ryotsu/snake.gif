open Document;

let toggle_button = status => {
  let class_list = get_element_by_id("startButton") |> get_classlist;
  switch status {
  | "stopped" => remove_class(class_list, "pure-button-disabled")
  | _ => add_class(class_list, "pure-button-disabled")
  };
};

let handle_keys = (channel, event) => {
  let keycode = keycode(event);
  let direction =
    switch keycode {
    | 37 => "left"
    | 38 => "up"
    | 39 => "right"
    | 40 => "down"
    | _ => "other"
    };
  if (direction != "other") {
    let _ = Phx.push("new_direction", {"direction": direction}, channel);
    ();
  };
};

let handle_recieve = (status, response) =>
  switch status {
  | "ok" => Json.Decode.(response |> field("status", string) |> toggle_button)
  | _ => Js.log2(status, response)
  };

let handle_start = (channel, _event) => {
  let _ = channel |> Phx.push("start", {"status": "start"});
  ();
};

let join_channel = socket => {
  let channel = Phx.initChannel("snake", socket);
  let _ =
    channel
    |> Phx.putOn("new_status", handle_recieve("ok"))
    |> Phx.joinChannel
    |> Phx.putReceive("ok", handle_recieve("ok"))
    |> Phx.putReceive("error", handle_recieve("error"));
  channel;
};

let hiss = socket => {
  let channel = join_channel(socket);
  let _ = add_event_listener(document, "keydown", handle_keys(channel));
  let button = get_element_by_id("startButton");
  let _ = add_event_listener(button, "click", handle_start(channel));
  ();
};
