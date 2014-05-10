require 'rubygems'
require 'bundler'
require 'rack'
require 'sidekiq/web'
require_relative 'app'

Bundler.require(:default, ENV['RACK_ENV'].to_sym)

Bittracktor::MultiTicker::App.new!

run Rack::URLMap.new({
  '/sidekiq' => Sidekiq::Web
})
