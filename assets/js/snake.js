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
    .addEventListener("click", (_evt) => handleStart(channel))

  let buttons = document.getElementsByClassName("button")
  for (let i = 0; i < 4; i++) {
    buttons[i].addEventListener("click", () => {
      if (document.getElementById("startButton").classList.contains("pure-button-disabled")) {
        channel
          .push("new_direction", { direction: buttons[i].id })
          .receive("error", e => console.log(e))
      }
    })
  }
}

let handleStart = (channel) => {
  channel
    .push("start", {})
    .receive("ok", resp => {
      toggleButton(resp.status)
    })
    .receive("error", resp => console.log(resp))
}

let toggleButton = (status) => {
  if (status == "stopped") {
    document.getElementById("startButton").classList.remove("pure-button-disabled")
  } else {
    document.getElementById("startButton").classList.add("pure-button-disabled")
  }
}

let key = {
  LEFT: 37,
  UP: 38,
  RIGHT: 39,
  DOWN: 40
};

let handleKeys = (event, channel) => {
  let keycode = event.keyCode || event.which
  let direction = matchKey(keycode)

  if (document.getElementById("startButton").classList.contains("pure-button-disabled")) {
    channel
      .push("new_direction", { direction: direction })
      .receive("error", e => console.log(e))
  }
};

let matchKey = (keycode) => {
  switch (keycode) {
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

export default initSnake;
