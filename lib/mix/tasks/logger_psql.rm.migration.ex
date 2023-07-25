defmodule Mix.Tasks.LoggerPsql.Rm.Migration do
  @moduledoc """
  Removes the migration file, used mostly for testing purposes.
  """
  use Mix.Task

  def run(_args) do
    files =
      File.cwd!()
      |> Kernel.<>("/priv/repo/migrations/*_logger_psql.exs")
      |> Path.wildcard()

    File.rm!(files)
  end
end
