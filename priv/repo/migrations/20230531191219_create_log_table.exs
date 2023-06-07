defmodule LoggerPSQL.Repo.Migrations.CreateLogTable do
  use Ecto.Migration

  def change do
    create table(:logs, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :level, :string
      add :application, :string
      add :domain, :string
      add :file, :string
      add :function, :string
      add :line, :string
      add :module, :string
      add :pid, :string
      add :time, :utc_datetime
      add :message, :string
      add :metadata, :map
      add :request_id, :string

      timestamps()
    end
  end
end
