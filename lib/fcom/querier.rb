# frozen_string_literal: true

require 'pty'

require_relative 'options_helpers.rb'

# This class executes a system command to retrieve the git history, which is passed through `rg`
# (ripgrep), and then ultimately is fed back to `fcom` for parsing.
class Fcom::Querier
  prepend MemoWise
  include ::Fcom::OptionsHelpers

  def initialize(options)
    @options = options
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  # rubocop:disable Metrics/MethodLength
  def query
    expression_to_match = search_string
    expression_to_match = Regexp.escape(expression_to_match).gsub('\\ ', ' ') unless regex_mode?

    if expression_to_match.nil? || expression_to_match.empty?
      puts('provide expression to match as first argument')
      exit
    end

    quote = expression_to_match.include?('"') ? "'" : '"'

    commands =
      filename_by_most_recent_containing_commit.map do |commit, path_at_commit|
        <<~COMMAND.squish
          git log
            --format="commit %s|%H|%an|%cr (%ci)"
            --patch
            --full-diff
            --topo-order
            --no-textconv
            #{%(--author="#{author}") if author}
            #{days_limiter}
            #{commit}
            --
            #{path_at_commit}
            |

          rg #{quote}(#{expression_to_match})|(^commit )|(^diff )#{quote}
            --color never
            #{'--ignore-case' if ignore_case?}
            #{@options[:rg_options]}
            |

          #{'exe/' if development?}fcom #{quote}#{search_string}#{quote}
            #{"--days #{days}" if days}
            #{'--regex' if regex_mode?}
            #{'--debug' if debug?}
            #{'--ignore-case' if ignore_case?}
            --path #{path_at_commit}
            --parse-mode
            --repo #{repo}
        COMMAND
      end

    previous_command_generated_output = false

    commands.each do |command|
      Fcom.logger.debug("Executing command: #{command}")

      # Add spacing if needed
      if previous_command_generated_output
        print "\n\n"
      end

      PTY.spawn(command) do |stdout, _stdin, _pid|
        any_bytes_seen_for_command = false

        # Read first byte to detect any output
        first_byte = stdout.read(1)

        any_bytes_seen_for_command = true

        if first_byte
          previous_command_generated_output = true

          print(first_byte)

          # Now read the rest line by line
          stdout.each_line { puts(it) }
        else
          previous_command_generated_output = false
        end
      rescue Errno::EIO
        if !any_bytes_seen_for_command
          previous_command_generated_output = false
        end
      end
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop:enable Metrics/CyclomaticComplexity

  private

  memo_wise \
  def filename_by_most_recent_containing_commit
    {
      most_recent_commit_with_file => path,
    }.merge(renames.transform_keys { "#{_1}^" })
  end

  memo_wise \
  def most_recent_commit_with_file
    if system(%(test -e "#{path}"))
      'HEAD'
    else
      `git log --all -1 --format="%H" -- "#{path}"`.rstrip
    end
  end

  memo_wise \
  def renames
    if path == Fcom::ROOT_PATH
      {}
    else
      command =
        'git log HEAD ' \
        "--format=%H --name-status --follow --diff-filter=R #{days_limiter} " \
        "-- '#{path}'"

      `#{command}`.
        split(/\n(?=[0-9a-f]{40})/).
        to_h do |sha_and_name_info|
          sha_and_name_info.
            match(/(?<sha>[0-9a-f]{40})\n\nR\d+\s+(?<previous_name>\S+)?/).
            named_captures.
            values_at('sha', 'previous_name')
        end
    end
  end

  memo_wise \
  def days_limiter
    if days
      "--since=#{days}.day"
    end
  end
end
