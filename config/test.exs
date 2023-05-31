import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :snake, SnakeWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "qsk1x47aHw5rIm3peRwL6ShWMaHcaD+K1QlCY67EHYPMTvg7rIgxPvlid4yY2iHe",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
