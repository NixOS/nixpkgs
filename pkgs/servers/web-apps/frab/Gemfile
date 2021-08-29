source 'https://rubygems.org'

if ENV['CUSTOM_RUBY_VERSION']
  ruby ENV['CUSTOM_RUBY_VERSION'] # i.e.: '2.3'
end

gem 'rails', '~> 4.2'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'

gem 'mysql2', group: :mysql
gem 'pg', group: :postgresql
gem 'sqlite3', group: :sqlite3

# Use Puma as the app server
gem 'puma'

# Capistrano for deployment
group :capistrano do
  gem 'airbrussh'
  gem 'capistrano', '~> 3.4.0', require: false
  gem 'capistrano-rails',   require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rvm',     require: false
  gem 'capistrano3-puma',   require: false
end

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-migrate-rails'
gem 'jquery-ui-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

gem 'activeresource'
gem 'acts_as_commentable'
gem 'bcrypt'
gem 'cancancan'
gem 'cocoon'
gem 'dotenv-rails'
gem 'haml'
gem 'localized_language_select', github: 'frab/localized_language_select', branch: 'master'
gem 'nokogiri'
gem 'paperclip', '~> 4.1'
gem 'paper_trail'
gem 'prawn', '< 1.0'
gem 'prawn_rails'
gem 'ransack'
gem 'ri_cal'
gem 'roust'
gem 'rqrcode'
#gem 'roust', :git => 'git@github.com:bulletproofnetworks/roust.git'
gem 'simple_form'
gem 'sucker_punch'
gem 'transitions', require: ['transitions', 'active_record/transitions']
gem 'will_paginate'

group :production do
  gem 'exception_notification'
end

group :development, :test do
  gem 'bullet'
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'letter_opener'
  gem 'faker'
end

group :test do
  gem 'database_cleaner'
  gem 'factory_girl_rails', '~> 4.0'
  gem 'shoulda'
end

group :doc do
  gem 'redcarpet'       # documentation
  gem 'github-markdown' # documentation
  gem 'yard'            # documentation
  # gem 'rails-erd'      # graph
  # gem 'ruby-graphviz', require: 'graphviz' # Optional: only required for graphing
end
