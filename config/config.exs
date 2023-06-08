import Config

config :logger_psql,
  ecto_repos: [LoggerPSQL.Repo],
  generators: [binary_id: true]

config :logger_psql, LoggerPSQL.Repo,
  database: "logger_psql_repo",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

config :logger_json, :backend,
  metadata: :all,
  json_encoder: Jason

config :logger_psql, :backend,
  level: :info,
  repo: LoggerPSQL.Repo,
  schema_name: "logs",
  prefix: "log",
  metadata_filter: [:ansi_color, :mfa, :gl]

config :logger,
  backends: [LoggerPSQL],
  level: :info

import_config "#{config_env()}.exs"
