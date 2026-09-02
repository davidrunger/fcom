# frozen_string_literal: true

RSpec.describe Fcom::Parser do
  subject(:parser) { Fcom::Parser.new(options) }

  let(:options) { stubbed_slop_options('the_search_string --repo username/reponame') }

  before do
    allow($stdin).to receive(:each) do |_stdin, &blk|
      StringIO.new(stubbed_stdin).each(&blk)
    end
  end

  describe '#parse' do
    subject(:parse) { parser.parse }

    after do
      expect($stdin).to have_received(:each).once
    end

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
      allow($stdout).to receive(:puts)

      parse

      expect($stdout).to have_received(:puts).with([
        'Add rubocop as a development dependency',
        '066c52f4 ( https://github.com/username/reponame/commit/066c52f4 )',
        'David Runger',
        '3 days ago (2019-12-28 10:33:45 -0800)',
      ]).once.ordered
      expect($stdout).to have_received(:puts).
        with('==============================================').once.ordered
      expect($stdout).to have_received(:puts).with('lib/fcom/version.rb').once.ordered
      expect($stdout).to have_received(:puts).
        with("\e[31m- this line matches the_search_string!\e[0m").once.ordered
      expect($stdout).to have_received(:puts).
        with("\e[32m+ this line also matches the_search_string!\e[0m").once.ordered
    end

    context 'when a search string matches only Git patch metadata' do
      let(:options) { stubbed_slop_options('path|file --repo username/reponame') }
      let(:stubbed_stdin) do
        <<~STUBBED_STDIN
          commit Matching commit|1111111111111111111111111111111111111111|Author|1 day ago
          diff --git a/Gemfile.lock b/Gemfile.lock
          new file mode 100755
          index 0000000..1111111
          --- a/Gemfile.lock
          +++ b/Gemfile.lock
          @@ -15 +17 @@ ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../../Gemfile",
          Binary files a/Gemfile.lock and b/Gemfile.lock differ
          rename from Gemfile.lock
          rename to Gemfile.lock
          \\ No newline at end of file
        STUBBED_STDIN
      end

      it 'does not print anything' do
        allow($stdout).to receive(:puts)

        parse

        expect($stdout).not_to have_received(:puts)
      end
    end

    context 'when a search string matches changed content' do
      let(:options) { stubbed_slop_options('path|file --repo username/reponame') }
      let(:output) { [] }
      let(:stubbed_stdin) do
        <<~STUBBED_STDIN
          commit Matching commit|1111111111111111111111111111111111111111|Author|1 day ago
          diff --git a/file.rb b/file.rb
          + path|file changed content
        STUBBED_STDIN
      end

      before do
        allow($stdout).to receive(:puts) { |*args| output.concat(args) }
      end

      it 'prints the changed line' do
        parse

        expect(output).to include("\e[32m+ path|file changed content\e[0m")
      end
    end

    context 'when the search string contains regex syntax' do
      let(:options) { stubbed_slop_options('the.search --repo username/reponame') }
      let(:output) { [] }
      let(:stubbed_stdin) do
        <<~STUBBED_STDIN
          commit Matching commit|1111111111111111111111111111111111111111|Author|1 day ago
          diff --git a/file.rb b/file.rb
          + this line contains the.search
          + this line contains theXsearch
          + this line has no match
        STUBBED_STDIN
      end

      before do
        allow($stdout).to receive(:puts) { |*args| output.concat(args) }
      end

      it 'interprets the search string as a regular expression' do
        parse

        expect(output).to include("\e[32m+ this line contains the.search\e[0m")
        expect(output).to include("\e[32m+ this line contains theXsearch\e[0m")
        expect(output).not_to include("\e[32m+ this line has no match\e[0m")
      end

      context 'when fixed strings are requested' do
        let(:options) do
          stubbed_slop_options('the.search --fixed-strings --repo username/reponame')
        end

        it 'interprets the search string as a fixed string' do
          parse

          expect(output).to include("\e[32m+ this line contains the.search\e[0m")
          expect(output).not_to include("\e[32m+ this line contains theXsearch\e[0m")
        end
      end
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
        allow($stdout).to receive(:puts)

        parse

        expect($stdout).to have_received(:puts).with([
          'First matching commit',
          '11111111 ( https://github.com/username/reponame/commit/11111111 )',
          'First Author',
          '1 day ago',
        ]).once.ordered
        expect($stdout).to have_received(:puts).
          with(Fcom::Parser::COMMIT_HEADER_SEPARATOR).once.ordered
        expect($stdout).to have_received(:puts).with('first_file.rb').once.ordered
        expect($stdout).to have_received(:puts).
          with("\e[32m+ the_search_string in the first commit\e[0m").once.ordered
      end
    end
  end
end
