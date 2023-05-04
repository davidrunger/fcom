# frozen_string_literal: true

# This module contains convenience methods that expose more directly the command options provided.
module Fcom::OptionsHelpers
  private

  def author
    @options[:author]
  end

  def days
    @options[:days]
  end

  def ignore_case?
    @options.ignore_case?
  end

  def path
    @options[:path]
  end

  def regex_mode?
    @options.regex?
  end

  def debug?
    @options.debug?
  end

  def development?
    @options.development?
  end

  def repo
    @options[:repo]
  end

  def search_string
    @options.arguments.first
  end
end
