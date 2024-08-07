# frozen_string_literal: true

require 'active_support/all'
require 'memo_wise'
require 'rainbow/refinement'
require 'slop'
require 'yaml'

using Rainbow

# This `Fcom` class is the namespace within which most of the gem's code is written.
# We need to define the class before requiring the modules.
# rubocop:disable Lint/EmptyClass
class Fcom
end
# rubocop:enable Lint/EmptyClass

Dir["#{File.dirname(__FILE__)}/fcom/*.rb"].each { |file| require file }

class Fcom
  ROOT_PATH = '.'

  class << self
    prepend MemoWise

    memo_wise \
    def logger
      Logger.new($stdout).tap do |logger|
        logger.formatter = ->(_severity, _datetime, _progname, msg) { "#{msg}\n" }
        # default the log level to WARN, but this can be set to `DEBUG` via the `--debug` CLI option
        logger.level = Logger::WARN
      end
    end

    memo_wise \
    def config_file_options
      Fcom::ConfigFileOptions.new
    end

    def warn_if_config_file_repo_option_missing
      if config_file_options.repo.blank?
        puts(<<~WARNING.rstrip.yellow)
          Warning: you have not specified a `repo` option in an `.fcom.yml` file.
          This will cause `fcom` to execute more slowly than necessary.
        WARNING
        puts('Execute `fcom --init` to create an `.fcom.yml` file.'.blue.bold)
        puts("See https://github.com/davidrunger/fcom/#readme for more info.\n\n")
      end
    end

    def define_slop_options(options)
      git_helpers = Fcom::GitHelpers.new
      default_repo = config_file_options.repo || git_helpers.repo || 'username/repo'

      options.string('--repo', 'GitHub repo (in form `username/repo`)', default: default_repo)
      options.integer('-d', '--days', 'number of days to search back')
      options.bool(
        '-r',
        '--regex',
        'interpret search string as a regular expression',
        default: false,
      )
      options.bool('-i', '--ignore-case', 'search case-insensitively', default: false)
      options.string(
        '-p',
        '--path',
        'path (directory or file) used to filter results',
        default: Fcom::ROOT_PATH,
      )
      options.string(
        '-a',
        '--author',
        'author',
      )
      options.string(
        '--rg-options',
        'additional options passed directly to `rg` (e.g. `--rg-options "--max-columns 1000"`)',
        default: '--max-columns=2000',
      )
      options.bool('--debug', 'print debugging info', default: false)
      options.bool('--parse-mode', 'whether we are in parse mode', default: false, help: false)
      options.bool('--development', 'use local `fcom` executable', default: false, help: false)
    end
  end
end
