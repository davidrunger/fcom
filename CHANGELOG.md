## Unreleased
[no unreleased changes yet]

## v0.5.0 (2023-06-20)
- Switch from `colorize` to `rainbow` for colored terminal output

## v0.4.3 (2023-05-30)
### Changed
- Move from Memoist to MemoWise

## v0.4.2 (2023-05-04)
[no unreleased changes yet]

## v0.4.1 (2023-05-04)
[no unreleased changes yet]

## v0.4.0 (2022-09-29)
[no unreleased changes yet]

## v0.3.4 (2021-01-26)
### Dependencies
- Bump `release_assistant` to `0.1.1.alpha`

## v0.3.3 (2021-01-26)
### Internal
- Source Rubocop rules/config from `runger_style` gem
- Use `release_assistant` to manage releases
- Ensure in PR CI runs that the current version contains "alpha" & that there's no git diff (e.g.
  due to failing to run `bundle` after updating the version)

## 0.3.2 - 2020-06-13
### Tests
- Extract RSpec performance summary reporting to a gem
  ([rspec_performance_summary](https://github.com/davidrunger/rspec_performance_summary/))

## 0.3.1 - 2020-06-06
### Docs
- Add note to README.md about `--init` option

## 0.3.0 - 2020-06-06
### Added
- Add `--init` flag to automatically create an `.fcom.yml` file

## 0.2.19 - 2020-06-05
### Docs
- Add badges to README.md (CI status, dependabot status, tag/version)

## 0.2.18 - 2020-06-05
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
