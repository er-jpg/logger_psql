defmodule LoggerPSQL.Log do
  @moduledoc false
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "logs" do
    field(:level, :string)
    field(:application, :string)
    field(:domain, :string)
    field(:file, :string)
    field(:function, :string)
    field(:line, :string)
    field(:module, :string)
    field(:pid, :string)
    field(:time, :utc_datetime)

    field(:message, :string)
    field(:metadata, :map)
    field(:request_id, :string)

    timestamps()
  end

  def changeset(log \\ %__MODULE__{}, params) do
    log
    |> cast(params, [
      :level,
      :application,
      :domain,
      :file,
      :function,
      :line,
      :module,
      :pid,
      :time,
      :metadata,
      :message,
      :request_id
    ])
  end
end
