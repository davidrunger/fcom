# frozen_string_literal: true

require_relative './options_helpers.rb'

# This class executes a system command to retrieve the git history, which is passed through `rg`
# (ripgrep), and then ultimately is fed back to `fcom` for parsing.
class Fcom::Querier
  include ::Fcom::OptionsHelpers

  def initialize(options)
    @options = options
  end

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/PerceivedComplexity
  def query
    expression_to_match = search_string
    expression_to_match = Regexp.escape(expression_to_match).gsub('\\ ', ' ') unless regex_mode?

    if expression_to_match.nil? || expression_to_match.size.zero?
      puts('provide expression to match as first argument')
      exit
    end

    quote = expression_to_match.include?('"') ? "'" : '"'

    command = <<~COMMAND.squish
      git log
        #{"--since=#{days}.day" unless days.nil?}
        --full-diff
        --format="commit %s|%H|%an|%cr (%ci)" --source -p #{path} |

      rg #{quote}(#{expression_to_match})|(^commit )|(^diff )#{quote} --color never |

      #{'exe/' if debug?}fcom #{quote}#{search_string}#{quote}
        #{"--days #{days}" if days}
        #{'--regex' if regex_mode?}
        #{'--debug' if debug?}
        --path #{path}
        --parse-mode
        --repo #{repo}
    COMMAND

    puts("Executing command: #{command}")
    system(command)
  end
  # rubocop:enable Metrics/PerceivedComplexity
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity
end
