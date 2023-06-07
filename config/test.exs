import Config

config :logger_psql, LoggerPSQL.Repo,
  username: "postgres",
  password: "postgres",
  database: "logger_psql_repo_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :logger_json, :backend,
  metadata: :all,
  json_encoder: Jason

config :logger,
  backends: [LoggerPSQL],
  level: :info
