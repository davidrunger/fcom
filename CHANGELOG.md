## Unreleased
- Use absolute path for parser in `--development` mode. This makes it possible not only to test queries within the `fcom` repo, but also in other repos.
- Stop printing two extra newlines after completion.

## v0.14.2 (2025-02-14)
- When using `--debug`, print the command used to query for renames and the parsed result.
- Track renames even across bulk renames. Fixes a bug where we might fail to track back through a rename that occurred in a commit with other renames.
- Search the git renaming history of the entire repo when filtering with a directory path. Fixes a bug wherein we failed to track renames into the specified target directory.
- Search over the diff of commits at the start of a search range, using `git rev-list`. This fixes a bug wherein sometimes a change in a commit renaming a file would not be included in the results.
- Only consider renames from outside of target directory. Fixes a bug wherein some commits could appear twice in the search results (and also performance was negatively impacted).

## v0.14.1 (2025-01-24)
- Stream results progressively. ([#757](https://github.com/davidrunger/fcom/pull/757))

## v0.14.0 (2024-12-10)
- Remove upper bounds on versions for all dependencies.

## v0.13.0 (2024-09-08)
- Add `--topo-order` (topological order) option to `git log` command

## v0.12.1 (2024-08-05)
- **Performance fix:** only search over renames when a path is given.
- **Performance fix:** only follow renames as far back as the `--days` option (if provided).

## v0.12.0 (2024-07-21)
- Default `--rg-options` to `--max-columns=2000`

## v0.11.0 (2024-07-16)
- Search back through renames

## v0.10.0 (2024-06-28)
- Enforce only major and minor parts of required Ruby version (loosening the
  required Ruby version from 3.3.3 to 3.3.0)

## v0.9.0 (2024-06-28)
- Print first 8 characters of commit SHA (not 7)

## v0.8.0 (2024-06-28)
- Print a helpful error message if ripgrep is not installed

## v0.7.1 (2024-06-28)
- Don't error if path option is a deleted file

## v0.7.0 (2024-06-15)
- Change primary branch name from `master` to `main`

## v0.6.0 (2024-02-02)
- Source Ruby version from `.ruby-version` file

## v0.5.1 (2023-07-22)
### Fixed
- Require and use Rainbow refinement in exe/fcom

### Internal
- Update `release` binstub for `runger_release_assistant` gem

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
