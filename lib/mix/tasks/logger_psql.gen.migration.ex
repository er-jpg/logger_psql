defmodule Mix.Tasks.LoggerPsql.Gen.Migration do
  use Mix.Task

  import Mix.Ecto
  import Mix.Generator

  def run(args) do
    no_umbrella!("ecto.gen.migration")

    args
    |> parse_repo()
    |> Enum.each(fn repo ->
      ensure_repo(repo, args)

      path = Ecto.Migrator.migrations_path(repo)

      source_path =
        :logger_psql
        |> Application.app_dir()
        |> Path.join("priv/templates/migration.exs.eex")

      config = Application.fetch_env!(:logger_psql, :backend)

      prefix = Keyword.get(config, :prefix, nil)

      schema_name =
        config
        |> Keyword.get(:schema_name, "logs")
        |> String.to_atom()

      generated_file =
        EEx.eval_file(source_path,
          module_prefix: app_module(),
          schema_name: schema_name,
          db_prefix: prefix
        )

        target_file = Path.join(path, "#{timestamp()}_logger_psql.exs")
        create_directory(path)
        create_file(target_file, generated_file)
    end)
  end

  defp app_module do
    Mix.Project.config()
    |> Keyword.fetch!(:app)
    |> to_string()
    |> Macro.camelize()
  end

  defp timestamp do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
  end

  defp pad(i) when i < 10, do: <<?0, ?0 + i>>
  defp pad(i), do: to_string(i)
end
