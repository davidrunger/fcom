# frozen_string_literal: true

# This `Fcom` module is the namespace within which most of the gem's code is written.
module Fcom
  ROOT_PATH = '.'

  def self.define_slop_options(options)
    git_helpers = Fcom::GitHelpers.new
    default_repo = git_helpers.repo || 'username/repo'

    options.string('--repo', 'GitHub repo (in form `username/repo`)', default: default_repo)
    options.integer('-d', '--days', 'number of days to search back')
    options.bool('-r', '--regex', 'interpret search string as a regular expression', default: false)
    options.bool('-i', '--ignore-case', 'search case-insensitively', default: false)
    options.string(
      '-p',
      '--path',
      'path (directory or file) used to filter results',
      default: Fcom::ROOT_PATH,
    )
    options.bool('--parse-mode', 'whether we are in parse mode', default: false, help: false)
    options.bool('--debug', 'activate debug mode', default: false, help: false)
  end
end

require_relative './fcom/git_helpers'
require_relative './fcom/parser'
require_relative './fcom/querier'
require_relative './fcom/version'
require 'active_support/all'
