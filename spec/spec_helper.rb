# frozen_string_literal: true

require 'bundler/setup'
Bundler.require(:test)
require_relative '../lib/fcom.rb'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with(:rspec) do |c|
    c.syntax = :expect
  end

  config.before(:suite) do
    # Some of the specs involve somewhat lengthy strings; increase the size of the printed output
    # for easier comparison of expected vs actual strings, in the event of a failure.
    # https://github.com/rspec/rspec-expectations/issues/ 991#issuecomment-302863645
    RSpec::Support::ObjectFormatter.default_instance.max_formatted_output_length = 2_000
  end
end

def stubbed_slop_options(arguments_string)
  options = Slop::Options.new
  Fcom.define_slop_options(options)
  options.parse(arguments_string.split(/\s+/))
end
