# LoggerPSQL

[![Hex.pm](https://img.shields.io/hexpm/v/logger_psql.svg)](https://hex.pm/packages/logger_psql)

LoggerPSQL is a Logger backend that emits the logs to a PostgreSQL Repo.

## Installation

Add `logger_psql` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:logger_psql, "~> 0.1.3"}
  ]
end
```

## Configuration

Add the backend to the logger configuration:

```elixir
config :logger,
  backends: [LoggerPSQL],
  level: :info
```

Then configure the logger_psql itself to the desired repo:

```elixir
config :logger_psql, :backend,
  level: :info,
  repo: MyApp.LogRepo,
  schema_name: "logs",
  prefix: "",
  metadata_filter: [:ansi_color, :color]
```

Some of the fields for configuration are:

  1. `level:` informs the lower level to be sent to the backend
  2. `repo:` module defined by ecto to be the desired storage, it is recommended to have a separated repo from the main repo of the application for this
  3. `schema_name:` table name to be created with the migration, if not set the value is `logs`
  4. `prefix:` database prefix, if not set the value is empty and goes directly into the ecto's default value of `public`
  5. `metadata_filter:` simple filter for metadata to not be stored in the database

## Migration

Generate and run the migrations from the CLI:

  1. `mix logger_psql.gen.migration`
  2. `mix ecto.migrate`

> **NOTE** After running the migrations please take note of changing the configs for `schema_name` and `prefix`, if needed to change after running the migrations, please create the migrations accordingly.

## Thanks

Many source code has been taken from original Elixir Logger `:console` and [logger_json](https://github.com/Nebo15/logger_json/) back-end source code, so I want to thank all it's authors and contributors.

Part of `Mix.Tasks.LoggerPsql.Gen.Migration` module was based in the guardian_db gen.migration task [guardian_db](https://github.com/ueberauth/guardian_db/blob/master/lib/mix/tasks/guardian_db.gen.migration.ex).
