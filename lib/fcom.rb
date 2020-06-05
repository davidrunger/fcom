# frozen_string_literal: true

require 'active_support/all'
require 'colorize'
require 'memoist'
require 'slop'
require 'yaml'

# This `Fcom` class is the namespace within which most of the gem's code is written.
# We need to define the class before requiring the modules.
class Fcom
end

Dir[File.dirname(__FILE__) + '/fcom/*.rb'].sort.each { |file| require file }

class Fcom
  ROOT_PATH = '.'

  class << self
    extend Memoist

    memoize \
    def logger
      Logger.new(STDOUT).tap do |logger|
        logger.formatter = ->(_severity, _datetime, _progname, msg) { "#{msg}\n" }
      end
    end

    memoize \
    def config_file_options
      Fcom::ConfigFileOptions.new
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
      options.bool('--debug', 'print debugging info', default: false)
      options.bool('--parse-mode', 'whether we are in parse mode', default: false, help: false)
      options.bool('--development', 'use local `fcom` executable', default: false, help: false)
    end
  end
end
