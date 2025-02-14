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

      context 'when a path option is not provided' do
        before do
          expect(options[:path]).to eq(Fcom::ROOT_PATH)
        end

        context 'when an author option is provided' do
          let(:options) { stubbed_slop_options('the_search_string --author "David Runger"') }

          it 'spawns a pseudoterminal with the expected command' do
            expect(PTY).
              to receive(:spawn).
              with(<<~COMMAND.squish)
                git rev-list #{`git rev-list --max-parents=0 HEAD`.rstrip} HEAD |
                git log
                --format="commit %s|%H|%an|%cr (%ci)"
                --patch
                --full-diff
                --topo-order
                --no-textconv
                --stdin
                --author="David Runger"
                -- .
                |
                rg "(the_search_string)|(^commit )|(^diff )" --color never --max-columns=2000 |
                fcom "the_search_string" --path . --parse-mode --repo testuser/testrepo
              COMMAND

            query
          end
        end
      end
    end
  end
end
