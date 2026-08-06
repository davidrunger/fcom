# frozen_string_literal: true

RSpec.describe Fcom::Parser do
  subject(:parser) { Fcom::Parser.new(options) }

  let(:options) { stubbed_slop_options('the_search_string --repo username/reponame') }

  before do
    expect($stdin).to receive(:each) do |_stdin, &blk|
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

    it 'prints stuff' do
      expect($stdout).to receive(:puts).with([
        'Add rubocop as a development dependency',
        '066c52f4 ( https://github.com/username/reponame/commit/066c52f4 )',
        'David Runger',
        '3 days ago (2019-12-28 10:33:45 -0800)',
      ]).ordered
      expect($stdout).to receive(:puts).
        with('==============================================').ordered
      expect($stdout).to receive(:puts).with('lib/fcom/version.rb').ordered
      expect($stdout).to receive(:puts).
        with("\e[31m- this line matches the_search_string!\e[0m").ordered
      expect($stdout).to receive(:puts).
        with("\e[32m+ this line also matches the_search_string!\e[0m").ordered

      parse
    end

    context 'when a commits option is provided' do
      let(:options) do
        stubbed_slop_options('the_search_string --repo username/reponame --commits 1')
      end
      let(:stubbed_stdin) do
        <<~STUBBED_STDIN
          commit First matching commit|1111111111111111111111111111111111111111|First Author|1 day ago
          diff --git a/first_file.rb b/first_file.rb
          + the_search_string in the first commit
          commit Second matching commit|2222222222222222222222222222222222222222|Second Author|2 days ago
          diff --git a/second_file.rb b/second_file.rb
          + the_search_string in the second commit
        STUBBED_STDIN
      end

      it 'prints no more than that number of commits' do
        expect($stdout).to receive(:puts).with([
          'First matching commit',
          '11111111 ( https://github.com/username/reponame/commit/11111111 )',
          'First Author',
          '1 day ago',
        ]).ordered
        expect($stdout).to receive(:puts).
          with(Fcom::Parser::COMMIT_HEADER_SEPARATOR).ordered
        expect($stdout).to receive(:puts).with('first_file.rb').ordered
        expect($stdout).to receive(:puts).
          with("\e[32m+ the_search_string in the first commit\e[0m").ordered

        parse
      end
    end
  end
end
