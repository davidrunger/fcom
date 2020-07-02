# frozen_string_literal: true

RSpec.describe Fcom::OptionsHelpers do
  subject(:options_helper) do
    instance = class_including_options_helpers.new
    instance.instance_variable_set(:@options, options)
    instance
  end

  let(:class_including_options_helpers) do
    klass = Class.new
    klass.include(Fcom::OptionsHelpers)
  end
  let(:options) { stubbed_slop_options(arguments_string) }
  let(:arguments_string) { 'the_search_target' }

  describe '#days' do
    subject(:days) { options_helper.send(:days) }

    context 'when a days option is provided' do
      let(:arguments_string) { "the_search_target --days #{days_option}" }
      let(:days_option) { 30 }

      it 'returns that number of days' do
        expect(days).to eq(days_option)
      end
    end

    context 'when a days option was not provided' do
      let(:arguments_string) { 'the_search_target' }

      it 'returns nil' do
        expect(days).to eq(nil)
      end
    end
  end
end
