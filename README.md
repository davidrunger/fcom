[![Build Status](https://travis-ci.org/davidrunger/fcom.svg?branch=master)](https://travis-ci.org/davidrunger/fcom)
[![Dependabot Status](https://api.dependabot.com/badges/status?host=github&repo=davidrunger/fcom)](https://dependabot.com)
![GitHub tag (latest SemVer pre-release)](https://img.shields.io/github/v/tag/davidrunger/fcom?include_prereleases)

# `fcom` ("find commit(s)")

This is a CLI tool that I use to parse the git history of a repo.

For example, if I use `fcom` to search this repo with `fcom "line.(green|red)" --regex --repo
davidrunger/fcom`, I get this output:

![](https://s3.amazonaws.com/screens.davidrunger.com/2019-12-28-20-50-09-oect2(1).png)

## Installation

The easiest way to install `fcom` is via the
[`specific_install`](https://github.com/rdp/specific_install) gem, which will pull and build the
`fcom` gem directly from the `master` branch of this repo:

```
gem install specific_install
gem specific_install davidrunger/fcom
```

## Dependencies

This gem assumes that you have `git` and `rg` (ripgrep) installed.

## Basic usage

```
$ fcom <search string> [options]
```

#### Available options and examples

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
  fcom "line.(green|red)" -d 365 --regex --repo davidrunger/fcom

    --repo             GitHub repo (in form `username/repo`)
    -d, --days         number of days to search back
    -r, --regex        interpret search string as a regular expression
    -i, --ignore-case  search case-insensitively
    -p, --path         path (directory or file) used to filter results
    --rg-options       additional options passed directly to `rg` (e.g. `--rg-options "--max-columns 1000"`)
    --debug            print debugging info
    --init             create an `.fcom.yml` config file
    -v, --version      print the version
    -h, --help         print this help information
```

## `.fcom.yml` config file
We highly recommend that you create an `.fcom.yml` file in any repository that you plan to search
with `fcom`.

**This file can be created automatically by executing `fcom --init`** in the relevant
repo/directory.

(You might (or might not) want to add `.fcom.yml` to your `~/.gitignore_global` file, so that this
file is not tracked by `git`.)

#### Example `.fcom.yml` config file
```yaml
repo: githubusername/reponame
```

The advantage of creating an `.fcom.yml` config file is that it will make the `fcom` command execute
more quickly, because time will not be wasted parsing the output of `git remote [...]` in order to
determine the URL of the repo's remote repository (which is used to construct links to matching
commits).

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
