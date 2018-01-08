[@bs.val] [@bs.scope "window"] [@bs.return nullable]
external user_token : option(string) = "user_id";

switch user_token {
| Some(token) =>
  let socket = Socket.connect(token);
  Snake.hiss(socket);
| None => ()
};
