# frozen_string_literal: true

RSpec.describe('fcom executable') do # rubocop:disable RSpec/DescribeClass
  describe 'help output' do
    subject(:help_output) { `./exe/fcom --help` }

    it 'includes the usage pattern, examples, and options w/ descriptions' do
      expect(help_output).to include('Usage: fcom <search string> [options]')

      expect(help_output).to include('Examples:')
      expect(help_output).to include('fcom options --path spec/')

      expect(help_output).to include('--path')
      expect(help_output).to include('print the version')
    end

    it 'is included in the README' do
      expect(File.read('README.md')).to include(<<~README_CONTENT.strip)
        ```
        $ fcom --help

        #{help_output.strip}
        ```
      README_CONTENT
    end
  end
end
