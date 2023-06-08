defmodule LoggerPSQL do
  @behaviour :gen_event

  alias LoggerPSQL.Log

  defstruct name: nil,
            format: nil,
            level: nil,
            metadata: nil,
            metadata_filter: nil,
            repo: nil,
            schema_name: nil

  @impl true
  def init(LoggerPSQL) do
    config = Application.fetch_env!(:logger_psql, :backend)
    {:ok, init(config, %__MODULE__{})}
  end

  def init({__MODULE__, opts}) when is_list(opts) do
    config = configure_merge(Application.get_env(:logger, :console), opts)
    {:ok, init(config, %__MODULE__{})}
  end

  defp init(config, state) do
    level = Keyword.get(config, :level)
    metadata = Keyword.get(config, :metadata, []) |> configure_metadata()
    metadata_filter = Keyword.get(config, :metadata_filter, [])
    repo = Keyword.get(config, :repo)
    schema_name = Keyword.get(config, :schema_name, "public")

    %{
      state
      | metadata: metadata,
        level: level,
        metadata_filter: metadata_filter,
        repo: repo,
        schema_name: schema_name
    }
  end

  @impl true
  def handle_call({:configure, opts}, state) do
    {:ok, :ok, configure(opts, state)}
  end

  @impl true
  def handle_event({_level, gl, {Logger, _, _, _}}, state) when node(gl) != node() do
    {:ok, state}
  end

  def handle_event({level, _gl, {Logger, msg, ts, md}}, %{} = state) do
    if is_level_okay(level, state.level) do
      insert_log(level, msg, ts, md, state)
    end

    {:ok, state}
  end

  def handle_event(:flush, state) do
    {:ok, state}
  end

  @impl true
  def handle_info({:DOWN, ref, _, pid, reason}, %{ref: ref}) do
    raise "device #{inspect(pid)} exited: " <> Exception.format_exit(reason)
  end

  def handle_info(_, state) do
    {:ok, state}
  end

  defp is_level_okay(lvl, min_level) do
    is_nil(min_level) or Logger.compare_levels(lvl, min_level) != :lt
  end

  defp insert_log(level, msg, _ts, md, %{repo: repo, schema_name: schema_name} = state) do
    metadata =
      md
      |> filter_metadata(state.metadata_filter)
      |> build_values()
      |> Enum.into(%{})

    changeset =
      metadata
      |> Map.merge(%{
        level: to_string(level),
        time: DateTime.from_unix!(Keyword.get(md, :time), :microsecond),
        message: msg,
        metadata: metadata
      })
      |> Log.changeset()

    data =
      changeset
      |> Map.get(:data)
      |> Ecto.put_meta(prefix: schema_name)

    %{changeset | data: data}
    |> repo.insert()
    |> case do
      {:ok, _struct} ->
        :ok

      {:error, error} ->
        raise "failure while storing to db console messages: " <> inspect(error)
    end
  end

  defp filter_metadata(metadata, :all), do: metadata

  defp filter_metadata(metadata, metadata_filter) do
    Stream.filter(metadata, fn {key, _v} -> key not in metadata_filter end)
  end

  defp build_values(metadata_stream) do
    metadata_stream
    |> Stream.map(fn {key, value} ->
      value =
        case value do
          nil -> ""
          value when is_bitstring(value) -> value
          value -> inspect(value, pretty: true)
        end

      {key, value}
    end)
  end

  defp configure_metadata(:all), do: :all
  defp configure_metadata(nil), do: :all
  defp configure_metadata(metadata), do: Enum.reverse(metadata)

  defp configure_merge(env, options) do
    Keyword.merge(env, options, fn
      :colors, v1, v2 -> Keyword.merge(v1, v2)
      _, _v1, v2 -> v2
    end)
  end

  defp configure(options, state) do
    config = configure_merge(Application.get_env(:logger, :console), options)
    Application.put_env(:logger, :console, config)
    init(config, state)
  end
end
