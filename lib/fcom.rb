# frozen_string_literal: true

# This `Fcom` module is the namespace within which most of the gem's code is written.
module Fcom
  def self.define_slop_options(options)
    git_helpers = Fcom::GitHelpers.new
    default_repo = git_helpers.repo || 'username/repo'

    options.string('--repo', 'GitHub repo (in form `username/repo`)', default: default_repo)
    options.integer('-d', '--days', 'number of days to search back')
    options.bool('-r', '--regex', 'interpret search string as a regular expression', default: false)
    options.bool('-p', '--parse-mode', 'whether we are in parse mode', default: false, help: false)
  end
end

require_relative './fcom/git_helpers'
require_relative './fcom/parser'
require_relative './fcom/querier'
require_relative './fcom/version'
