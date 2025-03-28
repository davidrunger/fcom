# frozen_string_literal: true

using Rainbow

# This class parses (and then reprints some of) STDIN according to the options passed to `fcom`.
class Fcom::Parser
  include ::Fcom::OptionsHelpers

  def initialize(options)
    @options = options
  end

  def parse
    expression_to_match = search_string
    expression_to_match = Regexp.escape(expression_to_match).gsub('\\ ', ' ') unless regex_mode?
    regex =
      Regexp.new(
        "((\\+|-)\\s?.*#{expression_to_match}.*|Omitted long (matching )?line)",
        ignore_case? ? Regexp::IGNORECASE : nil,
      )

    previous_commit = nil
    a_commit_has_matched = false
    filename = nil
    $stdin.each do |line|
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
          title, sha, author, date = previous_commit.split('|')
          short_sha = sha[0, 8]
          sha_with_url = "#{short_sha} ( https://github.com/#{repo}/commit/#{short_sha} )"

          puts("\n\n") if a_commit_has_matched # print commit separator, if needed
          puts([title, sha_with_url, author, date])
          puts('==============================================')

          previous_commit = nil
          a_commit_has_matched = true
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
  end

  private

  def path_match?(filename)
    return true if path == Fcom::ROOT_PATH

    filename.include?(path.delete_prefix('./'))
  end
end
