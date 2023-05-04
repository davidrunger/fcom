# frozen_string_literal: true

module Support; end

module Support::SlopHelpers
  def stubbed_slop_options(arguments_string)
    options = Slop::Options.new
    Fcom.define_slop_options(options)

    arguments_array = []
    arguments_string.scan(/("[^"]+"|\S+)/) { |match| arguments_array << match[0].delete('"') }
    options.parse(arguments_array)
  end
end
