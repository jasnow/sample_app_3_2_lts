source 'https://rubygems.org'

gem 'rake'

gem 'rails', '3.2.13'

### gem 'rails', '4.0.0.beta1'
### gem 'protected_attributes' # Rails 4.0 (instead of strong_params)
### gem 'psych' # ONLY FOR Ruby 2.0.0-preview1

gem 'rack'

gem 'gravatar_image_tag'

gem 'will_paginate'

# Asset template engines

### gem 'sass-rails', '4.0.0.beta1' #4.0: 
gem 'sass-rails'

gem 'coffee-script'
gem 'uglifier'

gem 'jquery-rails'

gem 'nokogiri'

gem 'json'

group :development, :test do
  gem 'pg'
end

group :production do
  gem 'pg'
end

group :development do
  gem "rspec-rails"
  gem 'annotate'
  gem 'faker'

  # See Railscast #402 for more info.
  gem 'better_errors' 
  gem 'binding_of_caller'
end

gem 'holepicker'

group :test do
  gem 'spork-rails'
### , :git => 'https://github.com/sahilm/spork-rails.git', :branch => 'rails-4'
  gem "rspec-rails"
  gem 'factory_girl_rails'

  gem 'webrat'

  # Pretty printed test output
  gem 'turn', :require => false
end
