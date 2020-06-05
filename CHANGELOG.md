## Unreleased
### Tests
- Stub `ConfigFileOptions#config_file_exists?` to return `false` in tests

## 0.2.17 - 2020-06-05
### Fixed
- Print warning about missing `.fcom.yml` config file before executing querier

## 0.2.16 - 2020-06-05
### Tests
- Don't print debug statement(s) when executing tests

## 0.2.15 - 2020-06-05
### Fixed
- Don't print empty spaces before the first matching commit

## 0.2.14 - 2020-06-05
### Added
- Print warning if `.fcom.yml` config file does not exist (or it does not specify a `repo` option)

## 0.2.13 - 2020-06-05
### Added
- Add support for an `.fcom.yml` config file (supporting only a `repo` option at this time)

## 0.2.12 - 2020-06-05
### Docs
- Update the illustrated `--help` output in `README.md` to reflect the `-i`/`--ignore-case` and
  `--debug` options.

## 0.2.11 - 2020-06-05
### Tests
- Added logging of how long each example takes to execute
- Stubbed `Fcom::GitHelpers#repo` in tests to improve spec performance

## 0.2.10 - 2020-06-05
### Changed
- Set `Fcom.logger.level` for both querier and parser

## 0.2.9 - 2020-06-05
### Changed
- Specify dependency versions

## 0.2.8 - 2020-06-05
## Added
- Add `--debug` option and only print the command(s) being executed if that option is used

## Fixed
- Added `activesupport` as a dependency of the `fcom` gem in the gemspec

## Changed
- Removed version locks for dependencies in gemspec

## 0.2.7 - 2020-06-05
### Maintenance
- Added release script

## 0.2.6 - 2020-06-05
### Added
- Allow searching case-insensitively via `-i`/`--ignore-case` option

## 0.2.5 - 2020-06-05
### Added
- Allow filtering results to a specific path (directory or file) via `-p`/`--path` option

### Tests
- Don't send email notifications about Travis build results

## 0.2.4 - 2019-12-31
### Tests
- Added tests

## 0.2.3 - 2019-12-29
### Added
- Determine default repo name from git origin remote, if possible

## 0.2.2 - 2019-12-28
### Changed
- Improved documentation

## 0.2.1 - 2019-12-28
### Added
- Add `--repo` option, which is used in the GitHub links that are printed for matching commits

## 0.2.0 - 2019-12-28
### Breaking changes
- Change how options should be provided to the `fcom` command
- Parse command argument/options with `slop` gem

## 0.1.0 - 2019-12-28
### Added
- Initial release
