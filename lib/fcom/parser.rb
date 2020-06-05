# frozen_string_literal: true

# This class parses (and then reprints some of) STDIN according to the options passed to `fcom`.
class Fcom::Parser
  include ::Fcom::OptionsHelpers

  def initialize(options)
    @options = options
  end

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
  def parse
    expression_to_match = search_string
    expression_to_match = Regexp.escape(expression_to_match).gsub('\\ ', ' ') unless regex_mode?
    regex =
      Regexp.new(
        "(\\+|-)\\s?.*#{expression_to_match}.*",
        ignore_case? ? Regexp::IGNORECASE : nil,
      )

    previous_commit = nil
    filename = nil

    # rubocop:disable Metrics/BlockLength
    STDIN.each do |line|
      line.chomp!
      if (match = line.match(/^commit (.*)/)&.[](1))
        previous_commit = match
      elsif line.match?(/^diff /)
        old_filename = line.match(%r{ a/(\S+)})&.[](1) || '[weird filename]'
        new_filename = line.match(%r{ b/(\S+)})&.[](1) || '[weird filename]'
        filename =
          case
          when old_filename == new_filename then old_filename
          else "#{old_filename} --> #{new_filename}"
          end
      elsif line.match?(regex) && (filename.blank? || path_match?(filename))
        if previous_commit
          puts("\n\n")
          title, sha, author, date = previous_commit.split('|')
          sha_with_url =
            "#{sha[0, 7]} ( https://github.com/#{repo}/commit/#{sha[0, 7]} )"
          puts([title, sha_with_url, author, date])
          puts('==============================================')
          previous_commit = nil
        end

        if filename
          puts(filename)
          filename = nil
        end

        if line.start_with?('+')
          puts(line.green)
        elsif line.start_with?('-')
          puts(line.red)
        else
          puts(line)
        end
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity

  private

  def path_match?(filename)
    return true if path == Fcom::ROOT_PATH

    filename.include?(path.sub(%r{\A\./}, ''))
  end
end
