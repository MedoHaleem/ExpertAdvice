# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :expert_advice,
  ecto_repos: [ExpertAdvice.Repo]

# Configures the endpoint
config :expert_advice, ExpertAdviceWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "rDKJ9nxjZpFtTX1OYvvF3dSGDazFGAsLediT9283tjH5GXsR+AsrEvILqLG8Qoju",
  render_errors: [view: ExpertAdviceWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ExpertAdvice.PubSub, adapter: Phoenix.PubSub.PG2]

config :scrivener_html, routes_helper: MyApp.Router.Helpers, view_style: :bootstrap
# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
