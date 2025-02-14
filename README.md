![GitHub tag (latest SemVer pre-release)](https://img.shields.io/github/v/tag/davidrunger/fcom?include_prereleases)

# `fcom` ("find commit(s)")

This is a CLI tool that I use to parse the git history of a repo.

For example, if I use `fcom` to search this repo with `fcom "line.(green|red)" --regex --repo
davidrunger/fcom`, I get this output:

![](https://s3.amazonaws.com/screens.davidrunger.com/2019-12-28-20-50-09-oect2(1).png)

<!--ts-->
   * [Installation](#installation)
   * [Dependencies](#dependencies)
   * [Basic usage](#basic-usage)
      * [Available options and examples](#available-options-and-examples)
   * [The .fcom.yml config file](#the-fcomyml-config-file)
      * [Example .fcom.yml config file](#example-fcomyml-config-file)
   * [Performance considerations for -p/--path option](#performance-considerations-for--p--path-option)
   * [Development](#development)
   * [Contributing](#contributing)
   * [License](#license)

<!-- Created by https://github.com/ekalinin/github-markdown-toc -->
<!-- Added by: david, at: Fri Feb 14 02:32:46 AM CST 2025 -->

<!--te-->

## Installation

```
gem install fcom
```

## Dependencies

This gem assumes that you have `git` and [`rg` (ripgrep)][ripgrep] installed.

[ripgrep]: https://github.com/BurntSushi/ripgrep

## Basic usage

```
$ fcom <search string> [options]
```

### Available options and examples

After installing, execute `fcom --help` to see usage examples and available options.

```
$ fcom --help

Usage: fcom <search string> [options]

Examples:
  fcom update
  fcom 'def update'
  fcom "def update" --days 60
  fcom "[Uu]ser.*slug" -d 365 --regex
  fcom options --path spec/
  fcom "line.(green|red)" -d 365 --regex --repo davidrunger/fcom -a "David Runger"

    --repo             GitHub repo (in form `username/repo`)
    -d, --days         number of days to search back
    -r, --regex        interpret search string as a regular expression
    -i, --ignore-case  search case-insensitively
    -p, --path         path (directory or file) used to filter results
    -a, --author       author
    --rg-options       additional options passed directly to `rg` (e.g. `--rg-options "--max-columns 1000"`)
    --debug            print debugging info
    --init             create an `.fcom.yml` config file
    -v, --version      print the version
    -h, --help         print this help information
```

## The `.fcom.yml` config file
We highly recommend that you create an `.fcom.yml` file in any repository that you plan to search
with `fcom`.

**This file can be created automatically by executing `fcom --init`** in the relevant
repo/directory.

(You might (or might not) want to add `.fcom.yml` to your `~/.gitignore_global` file, so that this
file is not tracked by `git`.)

### Example `.fcom.yml` config file

```yaml
repo: githubusername/reponame
```

The advantage of creating an `.fcom.yml` config file is that it will make the `fcom` command execute
more quickly, because time will not be wasted parsing the output of `git remote [...]` in order to
determine the URL of the repo's remote repository (which is used to construct links to matching
commits).

## Performance considerations for `-p`/`--path` option

The performance of `fcom`'s querying and parsing of git history can significantly depend upon the `-p`/`--path` option provided (or lack thereof):

1. **fastest:** provide a _file_ path as the target
2. **medium:** do not provide a `-p`/`--path` option (i.e. search the whole repository)
3. **slowest:** provide a `-p`/`--path` option that is a subdirectory

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run
the tests. You can also run `bin/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run (in this repository's root directory):

```
$ rm -f pkg/*.gem && rake build && gem install --local pkg/fcom-*.gem
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/davidrunger/fcom.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
