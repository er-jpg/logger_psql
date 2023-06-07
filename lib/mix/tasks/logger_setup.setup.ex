defmodule Mix.Tasks.LoggerPsql.Setup do
  use Mix.Task

  alias Mix.Tasks.Ecto.{Create, Migrate}

  @shortdoc "Setup LoggerPSQL DB and tables"

  def run(_argv) do
    Create.run(["-r", "LoggerPSQL.Repo"])
    Migrate.run(["-r", "LoggerPSQL.Repo"])
  end
end
