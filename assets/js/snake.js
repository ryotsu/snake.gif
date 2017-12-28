let key = {
  LEFT:   37,
  UP:     38,
  RIGHT:  39,
  DOWN:   40
};

let handleKeys = (event, channel) => {
  let keycode = event.keyCode || event.which
  let direction = matchKey(keycode)

  channel
    .push("new_direction", {direction: direction})
    .receive("error", e => console.log(e))
};

let matchKey = (keycode) => {
  switch(keycode) {
    case key.UP:
      return "up"
    case key.DOWN:
      return "down"
    case key.LEFT:
      return "left"
    case key.RIGHT:
      return "right"
  }
}

let toggleButton = (status) => {
  if (status == "stopped") {
    document.getElementById("startButton").classList.remove("pure-button-disabled")
  } else {
    document.getElementById("startButton").classList.add("pure-button-disabled")
  }
}

let handleStart = (channel) => {
  channel
    .push("start")
    .receive("ok", resp => {
      console.log(resp)
      toggleButton(resp.status)
    })
    .receive("error", e => console.log(e))
}

let initSnake = (socket) => {
  let channel = socket.channel("snake")
  channel.join()
    .receive("ok", resp => {
      toggleButton(resp.status)
    })
    .receive("error", resp => { console.log("Unable to join", resp) })

  channel.on("new_status", (resp) => {
    toggleButton(resp.status)
  })

  document.addEventListener("keydown", (evt) => handleKeys(evt, channel), false)
  document
    .getElementById("startButton")
    .addEventListener("click", (evt) => handleStart(channel))
}

export default initSnake;
