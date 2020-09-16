# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :case_cs_contact_manager,
  ecto_repos: [CaseCsContactManager.Repo]

# Configures the endpoint
config :case_cs_contact_manager, CaseCsContactManagerWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vDb62upxt6xH5pK+cregVUpFOKz4wgumtFAsJdiyXcQsohCI3N46yvMkWMf3608Q",
  render_errors: [view: CaseCsContactManagerWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: CaseCsContactManager.PubSub,
  live_view: [signing_salt: "+K8cqkNG"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
