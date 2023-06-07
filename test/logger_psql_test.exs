defmodule LoggerPSQLTest do
  use LoggerPSQL.DataCase
  # doctest LoggerPSQL

  require Logger

  setup_all do
    Logger.configure_backend(:console, metadata: [:application, :module])
    on_exit(fn -> Logger.configure_backend(:console, metadata: []) end)
  end

  # defp msg_with_meta(text) do
  #   msg("module=LoggerTest #{text}")
  # end

  # test "add_backend/1 and remove_backend/1" do
  #   assert :ok = Logger.remove_backend(LoggerPSQL)
  #   assert Logger.remove_backend(LoggerPSQL) == {:error, :not_found}

  #   assert capture_log(fn ->
  #            assert Logger.debug("hello", []) == :ok
  #          end) == ""

  #   assert {:ok, _pid} = Logger.add_backend(LoggerPSQL)
  #   assert Logger.add_backend(LoggerPSQL) == {:error, :already_present}
  # end

  test "info/2" do
    Logger.warn("walealkjsdklajsdaklj")

    assert capture_log(fn ->
             assert Logger.info("hello", []) == :ok
           end)

    # assert capture_log(:notice, fn ->
    #          assert Logger.info("hello", []) == :ok
    #        end) == ""

    # assert capture_log(:notice, fn ->
    #          assert Logger.info(raise("not invoked"), []) == :ok
    #        end) == ""
  end
end
