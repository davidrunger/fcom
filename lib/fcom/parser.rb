# frozen_string_literal: true

require 'colorize'
require_relative './options_helpers.rb'

# This class parses (and then reprints some of) STDIN according to the options passed to `fcom`.
class Fcom::Parser
  include ::Fcom::OptionsHelpers

  def initialize(options)
    @options = options
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/PerceivedComplexity
  # rubocop:disable Metrics/BlockLength
  def parse
    expression_to_match = search_string
    expression_to_match = Regexp.escape(expression_to_match).gsub('\\ ', ' ') unless regex_mode?
    regex = /(\+|\-)\s?.*#{expression_to_match}.*/

    previous_commit = nil
    filename = nil

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
      elsif line.match?(regex)
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
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop:enable Metrics/BlockLength
end
