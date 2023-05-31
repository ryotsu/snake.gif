let initSnake = (socket) => {
  let channel = socket.channel("snake")

  channel.join()
    .receive("ok", resp => {
      toggleButton(resp.status)
      updateScore(resp)
    })
    .receive("error", resp => { console.log("Unable to join", resp) })

  channel.on("new_status", (resp) => {
    toggleButton(resp.status)
  })

  channel.on("update_score", (resp) => {
    updateScore(resp)
  })

  document.addEventListener("keydown", (evt) => handleKeys(evt, channel), false)
  document
    .getElementById("startButton")
    .addEventListener("click", (_evt) => handleStart(channel))

  let buttons = document.getElementsByClassName("button")
  for (let i = 0; i < 4; i++) {
    buttons[i].addEventListener("click", () => {
      if (document.getElementById("startButton").classList.contains("cursor-not-allowed")) {
        channel
          .push("new_direction", { direction: buttons[i].id })
          .receive("error", e => console.log(e))
      }
    })
  }
}

let updateScore = (scores) => {
  document.getElementById("score").textContent = scores["score"]
  document.getElementById("highScore").textContent = scores["high_score"]
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
    let elem = document.getElementById("startButton")
    elem.classList.remove("cursor-not-allowed", "opacity-50")
    elem.classList.add("hover:bg-blue-700")
  } else {
    let elem = document.getElementById("startButton")
    elem.classList.add("cursor-not-allowed", "opacity-50")
    elem.classList.remove("hover:bg-blue-700")
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

  // Start the game on spacebar
  if (keycode == 32) {
    handleStart(channel)
  }

  let direction = matchKey(keycode)

  if (!document.getElementById("startButton").classList.contains("curson-not-allowed")) {
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
