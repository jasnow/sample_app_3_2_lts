source 'https://rubygems.org'

gem 'rails', :git => 'https://github.com/makandra/rails.git', :branch => '3-2-fixes'
gem 'ffi', '1.9.6'

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

group :production do
  gem 'pg'
end

group :development, :test do
  gem 'sqlite3'
  gem 'rspec-rails', '2.99.0'
end

group :development do
  gem 'annotate'
  gem 'faker'

  # See Railscast #402 for more info.
  gem 'better_errors' 
  gem 'binding_of_caller'
  gem 'dawnscanner', :require => false
end

gem 'holepicker'

group :test do
  gem 'spork-rails'
  gem 'factory_girl_rails'

  gem 'webrat'

  # Pretty printed test output
  gem 'turn', :require => false
end
