# frozen_string_literal: true

RSpec.describe Fcom::GitHelpers do
  subject(:git_helper) { Fcom::GitHelpers.new }

  describe '#repo' do
    subject(:repo) { git_helper.repo }

    context 'when Fcom::GitHelpers#repo is not stubbed' do
      before { allow_any_instance_of(Fcom::GitHelpers).to receive(:repo).and_call_original }

      context 'when `git remote ...` indicates that the remote is davidrunger/fcom' do
        before do
          expect_any_instance_of(Kernel).
            to receive(:`).
            with('git remote show origin').
            and_return(<<~GIT_REMOTE_OUTPUT)
              * remote origin
                Fetch URL: git@github.com:davidrunger/fcom.git
                Push  URL: git@github.com:davidrunger/fcom.git
                HEAD branch: master
                Remote branch:
                  master tracked
                Local branches configured for 'git pull':
                  add-spec-timing merges with remote master
                  master          merges with remote master
                  safe            merges with remote master
                Local ref configured for 'git push':
                  master pushes to master (up to date)
            GIT_REMOTE_OUTPUT
        end

        it 'returns a string in form "username/repo" representing the repo' do
          expect(repo).to eq('davidrunger/fcom')
        end
      end
    end
  end
end
