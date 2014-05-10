source 'https://rubygems.org', proxy: false

gem 'sinatra'
gem 'sinatra-contrib'
gem 'rake'
gem 'pry'
gem 'hirb'
gem 'workers'
gem 'redis'
gem 'pg'
gem 'sequel'
gem 'sidekiq'
gem 'puma'

group :development do
  gem 'capistrano'
  gem 'capistrano-rvm'
  gem 'capistrano-bundler'
  gem 'capistrano-sidekiq'
  gem 'capistrano3-puma'
end

group :test do
  gem 'database_cleaner'
  gem 'minitest'
  gem 'minitest-reporters'
  gem 'minitest-capybara'
  gem 'ansi'
  gem 'multi_json'
  gem 'simplecov', require: false
  gem 'factory_girl'
  gem 'webmock'
  gem 'vcr'
end

group :doc do
  gem 'sdoc', require: false
end
