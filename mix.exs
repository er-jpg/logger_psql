defmodule LoggerPSQL.MixProject do
  use Mix.Project

  @version "0.1.2"

  def project do
    [
      app: :logger_psql,
      description: description(),
      package: package(),
      docs: docs(),
      version: @version,
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases(),
      elixirc_paths: elixirc_paths(Mix.env())
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {LoggerPSQL.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:logger_json, "~> 5.1"},
      {:ex_doc, "~> 0.27", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:faker, "~> 0.17", only: :test}
    ]
  end

  defp description do
    "A Logger backend for PostgreSQL."
  end

  defp package do
    [
      maintainers: ["Bruno Saragosa"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/er-jpg/logger_psql"}
    ]
  end

  defp docs do
    [
      main: "readme",
      source_ref: "v#{@version}",
      source_url: "https://github.com/er-jpg/logger_psql",
      extras: [
        "README.md": [title: "Overview"],
        LICENSE: [title: "License"]
      ]
    ]
  end

  defp aliases do
    [
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: [
        "ecto.drop --quiet",
        "ecto.create --quiet",
        "logger_psql.gen.migration",
        "ecto.migrate",
        "test",
        "logger_psql.rm.migration"
      ]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]
end
