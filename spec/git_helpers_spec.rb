# frozen_string_literal: true

RSpec.describe Fcom::GitHelpers do
  subject(:git_helper) { Fcom::GitHelpers.new }

  describe '#repo' do
    subject(:repo) { git_helper.repo }

    it 'returns a string in form "username/repo" representing the repo' do
      expect(repo).to eq('davidrunger/fcom')
    end
  end
end
