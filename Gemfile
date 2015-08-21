source 'https://rubygems.org'

gem 'rails', git: 'https://github.com/makandra/rails.git', branch: '3-2-stable'

gem 'rake'
gem 'rack'
gem 'gravatar_image_tag'
gem 'will_paginate'
gem 'sass-rails'
gem 'coffee-script'
gem 'uglifier'
gem 'jquery-rails'
gem 'nokogiri'
gem 'json'
gem 'holepicker'
gem 'overcommit'

group :development do
  gem 'annotate'
  gem 'faker'

  # See Railscast #402 for more info.
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'dawnscanner', require: false
end

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails', '2.99.0'
end

group :test do
  gem 'spork-rails'
  gem 'factory_girl_rails'

  gem 'webrat'

  # Pretty printed test output
  gem 'turn', require: false
end

group :production do
  gem 'pg'
end
