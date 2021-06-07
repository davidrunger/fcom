# frozen_string_literal: true

module Support; end

module Support::SlopHelpers
  def stubbed_slop_options(arguments_string)
    options = Slop::Options.new
    Fcom.define_slop_options(options)
    options.parse(arguments_string.split(/\s+/))
  end
end
