defmodule LoggerPSQL.DataCase do
  use ExUnit.CaseTemplate
  import ExUnit.CaptureIO

  using do
    quote do
      alias LoggerPSQL.Repo

      import Ecto
      import Ecto.Query
      import LoggerPSQL.DataCase
    end
  end

  setup tags do
    pid = Ecto.Adapters.SQL.Sandbox.start_owner!(LoggerPSQL.Repo, shared: not tags[:async])
    on_exit(fn -> Ecto.Adapters.SQL.Sandbox.stop_owner(pid) end)
  end

  def msg(msg) do
    ~r/\d\d\:\d\d\:\d\d\.\d\d\d #{Regex.escape(msg)}/
  end

  def wait_for_handler(manager, handler) do
    unless handler in :gen_event.which_handlers(manager) do
      Process.sleep(10)
      wait_for_handler(manager, handler)
    end
  end

  def wait_for_logger() do
    try do
      :gen_event.which_handlers(Logger)
    catch
      :exit, _ ->
        Process.sleep(10)
        wait_for_logger()
    else
      _ ->
        :ok
    end
  end

  def capture_log(level \\ :debug, fun) do
    Logger.configure(level: level)

    capture_io(:user, fn ->
      fun.()
      Logger.flush()
    end)
  after
    Logger.configure(level: :debug)
  end
end
