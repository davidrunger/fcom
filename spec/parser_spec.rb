# frozen_string_literal: true

RSpec.describe Fcom::Parser do
  subject(:parser) { Fcom::Parser.new(options) }

  let(:options) { stubbed_slop_options('the_search_string --repo username/reponame') }

  before do
    expect(STDIN).to receive(:each) do |_stdin, &blk|
      StringIO.new(stubbed_stdin).each(&blk)
    end
  end

  describe '#parse' do
    subject(:parse) { parser.parse }

    let(:stubbed_stdin) do
      <<~STUBBED_STDIN
        commit Add rubocop as a development dependency|066c52f44a3977f55c1b457a25f084b66856bc41|David Runger|3 days ago (2019-12-28 10:33:45 -0800)
        diff --git a/lib/fcom/version.rb b/lib/fcom/version.rb
        - this line matches the_search_string!
        + this line also matches the_search_string!
        + this line doesn't match the search string
      STUBBED_STDIN
    end

    let(:expected_output) do
      <<~EXPECTED_OUTPUT
        Add rubocop as a development dependency
        066c52f ( https://github.com//commit/066c52f )
        David Runger
        3 days ago (2019-12-28 10:33:45 -0800)
      EXPECTED_OUTPUT
    end

    it 'prints stuff' do
      expect(STDOUT).to receive(:puts).with("\n\n").ordered
      expect(STDOUT).to receive(:puts).with([
        'Add rubocop as a development dependency',
        '066c52f ( https://github.com/username/reponame/commit/066c52f )',
        'David Runger',
        '3 days ago (2019-12-28 10:33:45 -0800)',
      ]).ordered
      expect(STDOUT).to receive(:puts).
        with('==============================================').ordered
      expect(STDOUT).to receive(:puts).with('lib/fcom/version.rb').ordered
      expect(STDOUT).to receive(:puts).
        with("\e[0;31;49m- this line matches the_search_string!\e[0m").ordered
      expect(STDOUT).to receive(:puts).
        with("\e[0;32;49m+ this line also matches the_search_string!\e[0m").ordered

      parse
    end
  end
end
