ExUnit.start()

alias LoggerPSQL.Repo

{:ok, _} = Ecto.Adapters.Postgres.ensure_all_started(Repo, :temporary)

{:ok, _pid} = Repo.start_link()
