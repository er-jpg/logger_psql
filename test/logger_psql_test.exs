defmodule LoggerPSQLTest do
  use LoggerPSQL.DataCase
  # doctest LoggerPSQL

  require Logger

  import Ecto.Query, warn: false

  alias LoggerPSQL.{Log, Repo}

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

  test "Stores to database message" do
    message = "Log example message"

    assert capture_log(fn ->
             assert Logger.info(message, []) == :ok
           end)

    assert %Log{message: ^message} =
             from(l in Log,
               where: l.message == ^message
             )
             |> Repo.one()
  end

  test "Long text message" do
    long_message = Faker.Lorem.paragraph(1..5)

    assert capture_log(fn ->
             assert Logger.info(long_message, []) == :ok
           end)

    assert %Log{message: ^long_message} =
             from(l in Log,
               where: l.message == ^long_message
             )
             |> Repo.one()
  end
end
