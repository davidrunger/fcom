# frozen_string_literal: true

require 'bundler/setup'
require 'pry'
require 'slop'
require 'fcom'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with(:rspec) do |c|
    c.syntax = :expect
  end
end

def stubbed_slop_options(arguments_string)
  options = Slop::Options.new
  Fcom.define_slop_options(options)
  options.parse(arguments_string.split(/\s+/))
end
