# frozen_string_literal: true

RSpec.describe Fcom::GitHelpers do
  subject(:git_helper) { Fcom::GitHelpers.new }

  describe '#repo' do
    subject(:repo) { git_helper.repo }

    context 'when Fcom::GitHelpers#repo is not stubbed' do
      # rubocop:disable RSpec/AnyInstance
      before { allow_any_instance_of(Fcom::GitHelpers).to receive(:repo).and_call_original }
      # rubocop:enable RSpec/AnyInstance

      context 'when `git remote -v` is stubbed' do
        before do
          # rubocop:disable RSpec/AnyInstance
          expect_any_instance_of(Kernel).
            to receive(:`).
            with('git remote -v').
            and_return(git_remote_output)
          # rubocop:enable RSpec/AnyInstance
        end

        context 'when `git remote -v` lists an origin with a .git extension' do
          let(:git_remote_output) do
            <<~GIT_REMOTE_OUTPUT
              origin  git@github.com:davidrunger/fcom.git (fetch)
              origin  git@github.com:davidrunger/fcom.git (push)
            GIT_REMOTE_OUTPUT
          end

          it 'returns a string in form "username/repo" representing the repo' do
            expect(repo).to eq('davidrunger/fcom')
          end
        end

        context 'when `git remote -v` lists an origin with no extension' do
          let(:git_remote_output) do
            <<~GIT_REMOTE_OUTPUT
              origin  https://github.com/rdy/fixture_builder (fetch)
              origin  https://github.com/rdy/fixture_builder (push)
            GIT_REMOTE_OUTPUT
          end

          it 'returns a string in form "username/repo" representing the repo' do
            expect(repo).to eq('rdy/fixture_builder')
          end
        end
      end
    end
  end
end
