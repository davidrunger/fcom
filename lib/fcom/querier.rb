# frozen_string_literal: true

# This class executes a system command to retrieve the git history, which is passed through `rg`
# (ripgrep), and then ultimately is fed back to `fcom` for parsing.
class Fcom::Querier
  def initialize(argv)
    @argv = argv
  end

  # rubocop:disable Metrics/AbcSize
  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/PerceivedComplexity
  def query
    days = @argv[1] || -1
    use_regex = (@argv[2] == 'regex')
    expression_to_match = @argv[0]
    expression_to_match = Regexp.escape(expression_to_match).gsub('\\ ', ' ') unless use_regex

    if expression_to_match.nil? || expression_to_match.size.zero?
      puts('provide expression to match as first argument')
      exit
    end

    quote = expression_to_match.include?('"') ? "'" : '"'
    # rubocop:disable Style/IfUnlessModifier
    command = <<~COMMAND.tr("\n", ' ')
      git log #{"--since=#{days}.day" unless days == -1} --full-diff --format="commit %s|%H|%an|%cr (%ci)" --source -p . |
        rg #{quote}(#{expression_to_match})|(^commit )|(^diff )#{quote} --color never |
        fcom #{quote}#{@argv[0]}#{quote} #{@argv[1] || 10_000} #{@argv[2] || 'dummy_placeholder_for_regex'} PARSE_MODE=TRUE
    COMMAND
    # rubocop:enable Style/IfUnlessModifier
    puts("Executing command: #{command}")
    system(command)
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/CyclomaticComplexity
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/PerceivedComplexity
end
