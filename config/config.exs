# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :blog_vttkieu,
  ecto_repos: [BlogVttkieu.Repo]



# Configures the endpoint
config :blog_vttkieu, BlogVttkieuWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0+NUp14gmT0iZb76zkJ75iyW7IqwV585UtU7wupZ04GQ3tzeuBeomwU+iPEtkwG3",
  render_errors: [view: BlogVttkieuWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: BlogVttkieu.PubSub,
  live_view: [signing_salt: "dXLZDOyI"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :scrivener_html,
  routes_helper: BlogVttkieu.Router.Helpers,
  view_style: :bootstrap

# config :blog_vttkieu, :pow,
#   user: BlogVttkieu.Blog.User
#   repo: BlogVttkieu.Repo


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
