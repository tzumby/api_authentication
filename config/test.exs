use Mix.Config


config :api_authentication, ApiAuthentication,
repo: ApiAuthentication.Test.Repo

config :api_authentication, ApiAuthentication.Test.Repo, [
  adapter: Ecto.Adapters.Postgres,
  database: "api_authentication_#{Mix.env}",
  username: "phoenix",
  password: "q1w2e3r4t5",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  priv: "priv/test"
]

config :api_authentication, :ecto_repos, [ApiAuthentication.Test.Repo]
