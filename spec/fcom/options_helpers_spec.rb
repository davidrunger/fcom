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

  describe '#commits' do
    subject(:commits) { options_helper.send(:commits) }

    context 'when a commits option is provided' do
      let(:arguments_string) { "the_search_target -c #{commits_option}" }
      let(:commits_option) { 5 }

      it 'returns that number of commits' do
        expect(commits).to eq(commits_option)
      end
    end

    context 'when a commits option was not provided' do
      it 'returns nil' do
        expect(commits).to eq(nil)
      end
    end
  end

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

  describe '#fixed_strings?' do
    subject(:fixed_strings?) { options_helper.send(:fixed_strings?) }

    context 'when a fixed strings option is provided' do
      let(:arguments_string) { 'the_search_target --fixed-strings' }

      it 'returns true' do
        expect(fixed_strings?).to eq(true)
      end
    end

    context 'when a fixed strings option was not provided' do
      it 'returns false' do
        expect(fixed_strings?).to eq(false)
      end
    end
  end
end
