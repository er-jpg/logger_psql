defmodule LoggerPSQL.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LoggerPSQL.Repo
    ]

    opts = [strategy: :one_for_one, name: LoggerPSQL.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
