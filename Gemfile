# frozen_string_literal: true

ruby '3.2.2'

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in fcom.gemspec
gemspec

group :development, :test do
  gem 'bundler', require: false
  gem 'pry'
  gem 'pry-byebug'
  gem 'rake', require: false
  gem 'rspec', require: false
  gem 'rubocop', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rake', require: false
  gem 'rubocop-rspec', require: false
  gem 'runger_style', require: false
end

group :development do
  gem 'runger_release_assistant', require: false
end
