let gen_string = length => {
  let gen = () =>
    switch (Random.int(26 + 26 + 10)) {
    | n when n < 26 => int_of_char('a') + n
    | n when n < 26 + 26 => int_of_char('A') + n - 26
    | n => int_of_char('0') + n - 26 - 26
    };
  let gen = (_) => String.make(1, char_of_int(gen()));
  String.concat("", Array.to_list(Array.init(length, gen)));
};

let handle_keys = (channel, keycode) => {
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

let handle_recieve = (status, change_status, response) =>
  switch status {
  | "ok" => Json.Decode.(response |> field("status", string) |> change_status)
  | _ => Js.log2(status, response)
  };

let handle_start = channel => {
  let _ = channel |> Phx.push("start", {"status": "start"});
  ();
};

let join_channel = (socket, change_status) => {
  let channel = Phx.initChannel("snake", socket);
  let _ =
    channel
    |> Phx.putOn("new_status", handle_recieve("ok", change_status))
    |> Phx.joinChannel
    |> Phx.putReceive("ok", handle_recieve("ok", change_status))
    |> Phx.putReceive("error", handle_recieve("error", change_status));
  channel;
};

let str = ReasonReact.stringToElement;

let unwrap =
  fun
  | Some(v) => v
  | None => raise(Invalid_argument("Passed `None` to unwrap"));

type action =
  | KeyDown(int)
  | Start
  | Joined(Phx.Channel.t)
  | NewStatus(string);

type status =
  | Running
  | Stopped;

type state = {
  status,
  channel: option(Phx.Channel.t)
};

let component = ReasonReact.reducerComponent("Snake");

let make = _children => {
  ...component,
  initialState: () => {status: Running, channel: None},
  reducer: (action, {channel} as state) =>
    switch action {
    | KeyDown(key) =>
      ReasonReact.SideEffects((_self => handle_keys(unwrap(channel), key)))
    | Start =>
      ReasonReact.UpdateWithSideEffects(
        {...state, status: Running},
        (_self => handle_start(unwrap(channel)))
      )
    | Joined(channel) => ReasonReact.Update({...state, channel: Some(channel)})
    | NewStatus(status) =>
      ReasonReact.Update({
        ...state,
        status: status == "stopped" ? Stopped : Running
      })
    },
  subscriptions: self => [
    Sub(
      () => {
        let user_id = gen_string(16);
        let socket = Socket.connect(user_id);
        let change_status = status => self.send(NewStatus(status));
        let channel = join_channel(socket, change_status);
        self.send(Joined(channel));
        (socket, channel);
      },
      ((socket, channel)) => {
        let _ = Phx.leaveChannel(channel);
        let _ = Phx.disconnectSocket(socket);
        ();
      }
    )
  ],
  render: ({state: {status}, send}) =>
    <div className="centered">
      <div className="box"> <img id="snake" src="/snake.gif" /> </div>
      <div className="box">
        <button
          id="startButton"
          className=(
            "pure-button pure-button-primary"
            ++ (status == Running ? " pure-button-disabled" : "")
          )
          autoFocus=Js.true_
          onKeyDown=(evt => send(KeyDown(ReactEventRe.Keyboard.which(evt))))
          onClick=(_evt => send(Start))>
          (str("Start Game"))
        </button>
      </div>
    </div>
};
