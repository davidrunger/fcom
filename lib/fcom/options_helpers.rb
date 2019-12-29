# frozen_string_literal: true

# This module contains convenience methods that expose more directly the command options provided.
module Fcom::OptionsHelpers
  private

  def days
    @options[:days]
  end

  def regex_mode?
    @options.regex?
  end

  def repo
    @options[:repo]
  end

  def search_string
    @options.arguments.first
  end
end
