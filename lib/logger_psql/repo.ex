defmodule LoggerPSQL.Repo do
  use Ecto.Repo,
    otp_app: :logger_psql,
    adapter: Ecto.Adapters.Postgres,
    log: false
end
