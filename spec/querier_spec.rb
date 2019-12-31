# frozen_string_literal: true

RSpec.describe Fcom::Querier do
  subject(:querier) { Fcom::Querier.new(options) }

  let(:options) { Slop::Options.new.parse(%w[the_search_string]) }

  describe '#query' do
    subject(:query) { querier.query }

    it 'executes a #system call' do
      expect_any_instance_of(Kernel).to receive(:system)

      query
    end
  end
end
