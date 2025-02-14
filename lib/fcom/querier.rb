# frozen_string_literal: true

require 'pp'
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
        commit_without_caret = commit.first(40)

        start_of_log =
          filtered_renames.
            drop_while { it.first != commit_without_caret }.
            detect { it.last == path_at_commit }&.
            first ||
          first_commit_sha

        <<~COMMAND.squish
          git log
            --format="commit %s|%H|%an|%cr (%ci)"
            --patch
            --full-diff
            --topo-order
            --no-textconv
            #{%(--author="#{author}") if author}
            #{days_limiter}
            #{start_of_log}..#{commit}
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
    [
      [most_recent_commit_with_file, path],
    ] + filtered_renames.map do |commit, previous_name|
      ["#{commit}^", previous_name]
    end
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
  def filtered_renames
    filtered_renames =
      if path == Fcom::ROOT_PATH
        []
      elsif path == path_for_git_log_renames_query
        # (Path is a file.)
        full_renames_history_for_path_for_git_log_renames_query
      else
        # (Path is a non-root directory.)
        already_selected = Set.new
        path_with_trailing_slash = File.join(path, '/').to_s

        renames_landing_in_target_directory =
          full_renames_history_for_path_for_git_log_renames_query.
            select do |(_commit, _previous_name, new_name)|
              (
                new_name.start_with?(path_with_trailing_slash) &&
                !already_selected.include?(new_name)
              ).tap do |is_most_recent_rename_into_target_directory|
                if is_most_recent_rename_into_target_directory
                  already_selected << new_name
                end
              end
            end

        traced_back_renames(renames_landing_in_target_directory.map(&:last))
      end

    Fcom.logger.debug(<<~LOG)
      Filtered renames:
      #{filtered_renames.pretty_inspect}
    LOG

    filtered_renames
  end

  def traced_back_renames(new_file_names)
    new_file_names_of_interest = Set.new(new_file_names)

    full_renames_history_for_path_for_git_log_renames_query.
      select do |(_commit, previous_name, new_name)|
        new_file_names_of_interest.include?(new_name).tap do |is_rename_of_interest|
          if is_rename_of_interest
            new_file_names_of_interest << previous_name
          end
        end
      end
  end

  memo_wise \
  def days_limiter
    if days
      "--since=#{days}.day"
    end
  end

  memo_wise \
  def full_renames_history_for_path_for_git_log_renames_query
    command =
      'git log HEAD ' \
      "--format=%H --name-status --follow --diff-filter=R #{days_limiter} " \
      "-- '#{path_for_git_log_renames_query}'"

    Fcom.logger.debug("Querying renames with: #{command}")

    `#{command}`.
      split(/\n(?=[0-9a-f]{40})/).
      flat_map do |sha_and_rename_info_lines|
        sha, rename_info_lines =
          sha_and_rename_info_lines.
            match(/(?<sha>[0-9a-f]{40})\n\n(?<rename_info_lines>R\d+.*)/m).
            named_captures.
            values_at('sha', 'rename_info_lines')

        rename_info_lines.lines.map do |rename_info_line|
          previous_name, new_name =
            rename_info_line.
              match(/\AR\d+\s+(?<previous_name>\S+)\s+(?<new_name>\S+)/).
              named_captures.
              values_at('previous_name', 'new_name')

          [sha, previous_name, new_name]
        end
      end.tap do |renames|
        Fcom.logger.debug(<<~LOG)
          Full renames history for '#{path_for_git_log_renames_query}':
          #{renames.pretty_inspect}
        LOG
      end
  end

  memo_wise \
  def path_for_git_log_renames_query
    File.directory?(path) ? Fcom::ROOT_PATH : path
  end

  memo_wise \
  def first_commit_sha
    `git rev-list --max-parents=0 HEAD`.rstrip
  end
end
