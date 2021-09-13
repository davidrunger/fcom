# frozen_string_literal: true

require 'bundler/setup'
Bundler.require(:test)
require_relative '../lib/fcom.rb'
Dir['spec/support/**/*.rb'].sort.each { |file| require("./#{file}") }

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with(:rspec) do |c|
    c.syntax = :expect
  end

  config.include(Support::SlopHelpers)

  config.before(:suite) do
    # Some of the specs involve somewhat lengthy strings; increase the size of the printed output
    # for easier comparison of expected vs actual strings, in the event of a failure.
    # https://github.com/rspec/rspec-expectations/issues/ 991#issuecomment-302863645
    RSpec::Support::ObjectFormatter.default_instance.max_formatted_output_length = 2_000
  end

  config.before(:each) do
    # stub this method in all tests because otherwise it calls `git remote ...` which is really slow
    # rubocop:disable RSpec/AnyInstance
    allow_any_instance_of(Fcom::GitHelpers).to receive(:repo).and_return('testuser/testrepo')
    # rubocop:enable RSpec/AnyInstance

    # pretend that `.fcom.yml` doesn't exist in tests
    # rubocop:disable RSpec/AnyInstance
    allow_any_instance_of(Fcom::ConfigFileOptions).
      to receive(:config_file_exists?).
      and_return(false)
    # rubocop:enable RSpec/AnyInstance
  end
end
