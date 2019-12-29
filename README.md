# `fcom` ("find commit(s)")

This is a CLI tool that I use to parse the git history of a repo.

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

## Usage

```
$ fcom <search string> [number of days to search] [enter "regex" if search string should be interpreted as a regex]
```

#### Examples

```
$ fcom --help

Usage: fcom <search string> [options]

Examples:
  fcom update
  fcom 'def update'
  fcom "def update" --days 60
  fcom "[Uu]ser.*slug" -d 365 --regex

    -d, --days        number of days to search back
    -r, --regex       interpret search string as a regular expression
    -v, --version     print the version
    -h, --help        print this help information
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run
the tests. You can also run `bin/console` for an interactive prompt that will allow you to
experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new
version, update the version number in `version.rb`, and then run `bundle exec rake release`, which
will create a git tag for the version, push git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/davidrunger/fcom.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
