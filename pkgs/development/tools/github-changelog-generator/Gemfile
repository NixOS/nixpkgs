# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

gemspec

group :development, :test do
  gem "bundler"
  gem "overcommit", ">= 0.31"
  gem "rake"
  gem "rubocop", ">= 0.50"
  gem "yard-junk"
end

group :development do
  gem "bump"
end

group :test do
  gem "codeclimate-test-reporter", "~> 1.0"
  gem "coveralls", "~>0.8", require: false
  gem "json"
  gem "multi_json"
  gem "rspec", "< 4"
  gem "simplecov", "~>0.10", require: false
  gem "vcr"
  gem "webmock"
end
