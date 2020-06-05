# frozen_string_literal: true

ruby '2.7.1'

source 'https://rubygems.org'

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in fcom.gemspec
gemspec

group :development, :test do
  gem 'bundler', require: false
  gem 'guard-espect', require: false, github: 'davidrunger/guard-espect'
  gem 'pry'
  gem 'pry-byebug'
  gem 'rake', require: false
  gem 'rspec', require: false
  gem 'rubocop', require: false
end
