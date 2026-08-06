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
                --diff-algorithm=default
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

        context 'when a commits option is provided' do
          let(:options) { stubbed_slop_options('the_search_string --commits 3') }

          it 'passes the option to the parser' do
            expect(PTY).
              to receive(:spawn).
              with(a_string_including('fcom "the_search_string" --commits 3'))

            query
          end
        end
      end
    end

    context 'when a search spans multiple paths' do
      let(:options) { stubbed_slop_options('the_search_string --commits 2') }

      before do
        allow(querier).to receive(:filename_by_most_recent_containing_commit).and_return([
          %w[newest new_path],
          %w[older old_path],
          %w[oldest oldest_path],
        ])
        allow(querier).to receive(:print)
        allow(querier).to receive(:puts)
      end

      it 'applies the limit across the combined output' do
        expect(querier).
          to receive(:query_command).
          with('newest', 'new_path', 'the_search_string', '"', 2).
          ordered.
          and_return('first command')
        expect(PTY).
          to receive(:spawn).
          with('first command').
          ordered.
          and_yield(
            StringIO.new("First commit\n#{Fcom::Parser::COMMIT_HEADER_SEPARATOR}\n"),
            nil,
            nil,
          )
        expect(querier).
          to receive(:query_command).
          with('older', 'old_path', 'the_search_string', '"', 1).
          ordered.
          and_return('second command')
        expect(PTY).
          to receive(:spawn).
          with('second command').
          ordered.
          and_yield(
            StringIO.new("Second commit\n#{Fcom::Parser::COMMIT_HEADER_SEPARATOR}\n"),
            nil,
            nil,
          )

        query
      end
    end
  end
end
