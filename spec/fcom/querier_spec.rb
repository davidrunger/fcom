# frozen_string_literal: true

RSpec.describe Fcom::Querier do
  subject(:querier) { Fcom::Querier.new(options) }

  let(:options) { stubbed_slop_options('the_search_string') }

  describe '#query' do
    subject(:query) { querier.query }

    context 'when a system call indicates that the current directory exists' do
      before do
        expect(querier).
          to receive(:system).
          with('test -e "."').
          and_return(true)
      end

      context 'when there have been no file renames' do
        before do
          expect(querier).
            to receive(:`).
            with("git log HEAD --format=%H --name-status --follow --diff-filter=R -- '.'").
            and_return('')
        end

        it 'executes a backticks system call with the expected command' do
          expect(querier).
            to receive(:`).
            with(<<~COMMAND.squish).
              git log --format="commit %s|%H|%an|%cr (%ci)" --patch --full-diff --no-textconv
                HEAD -- . |
              rg "(the_search_string)|(^commit )|(^diff )" --color never |
              fcom "the_search_string" --path . --parse-mode --repo testuser/testrepo
            COMMAND
            and_return('')

          query
        end

        context 'when an author option is provided' do
          let(:options) { stubbed_slop_options('the_search_string --author "David Runger"') }

          it 'executes a backticks system call with the expected command' do
            expect(querier).
              to receive(:`).
              with(<<~COMMAND.squish).
                git log
                --format="commit %s|%H|%an|%cr (%ci)"
                --patch --full-diff --no-textconv
                --author="David Runger"
                HEAD
                -- .
                |
                rg "(the_search_string)|(^commit )|(^diff )" --color never |
                fcom "the_search_string" --path . --parse-mode --repo testuser/testrepo
              COMMAND
              and_return('')

            query
          end
        end
      end
    end
  end
end
