import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :flight_simulator, FlightSimulatorWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "Cw7/rJpmPZK+eeyPJIMPDOrrRcOyuLHB7BDChD1WUBeNL2EtAQM9fvd4ngiYUeoL",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
