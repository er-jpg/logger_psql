# Changelog

## [0.1.2] - 2023-07-25

Fixing message field.

### Added
  - More test coverage

### Changed
  - Tests suite, if contributing from older version, run `MIX_ENV=test mix ecto.reset && mix test` just once then can be used just `mix test`
  - Added `schema_prefix` in Log Schema
  - Changed message field in database to `text` allowing a bigger message to be stored, if needs to use this, please create a migration
    ```elixir
      alter table(:logs) do
        modify(:message, :text)
      end
    ```
  - Bumped elixir version to 1.15

### Fixed
  - Fixes [https://github.com/er-jpg/logger_psql/issues/1](#1), allowing messages other than string to be inserted
  - Typos in documentation
  - Fixed if in config prefix was set to an empty string, it would fail

## [0.1.1] - 2023-06-09

Publish and improvements to initial usage and implementation.

### Added
  - Added task to create migration for the developer
  - Possibility to add a prefix

### Changed
### Fixed

## [0.1.0] - 2023-06-07

Initial Release of the package.

### Added
  - Initial implementation of the logger backend, adding the possibility to store logs into PostgreSQL
  - Added credo code lint
  - Added License

### Changed
### Fixed