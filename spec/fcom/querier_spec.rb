# frozen_string_literal: true

RSpec.describe Fcom::Querier do
  subject(:querier) { Fcom::Querier.new(options) }

  let(:options) { stubbed_slop_options('the_search_string') }

  describe '#query' do
    subject(:query) { querier.query }

    it 'executes a #system call with the expected command' do
      # rubocop:disable RSpec/AnyInstance
      expect_any_instance_of(Kernel).
        to receive(:system).
        with(<<~COMMAND.squish)
          git log --full-diff --no-textconv --format="commit %s|%H|%an|%cr (%ci)" --source -p . |
          rg "(the_search_string)|(^commit )|(^diff )" --color never |
          fcom "the_search_string" --path . --parse-mode --repo testuser/testrepo
        COMMAND
      # rubocop:enable RSpec/AnyInstance

      query
    end

    context 'when an author option is provided' do
      let(:options) { stubbed_slop_options('the_search_string --author "David Runger"') }

      it 'executes a #system call with the expected command' do
        # rubocop:disable RSpec/AnyInstance
        expect_any_instance_of(Kernel).
          to receive(:system).
          with(<<~COMMAND.squish)
            git log
              --author="David Runger"
              --full-diff
              --no-textconv
              --format="commit %s|%H|%an|%cr (%ci)"
              --source -p . |
            rg "(the_search_string)|(^commit )|(^diff )" --color never |
            fcom "the_search_string" --path . --parse-mode --repo testuser/testrepo
          COMMAND
        # rubocop:enable RSpec/AnyInstance

        query
      end
    end
  end
end
