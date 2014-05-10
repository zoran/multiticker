require 'redis'
require 'sidekiq'
require 'sidekiq/web'
require 'sinatra/base'

REDIS_CONN = Redis.connect(
  url: 'redis://multiticker.botradex.com:6380/',
  password: ENV['MULTITICKER_REDIS_PASSWORD']
)

Sidekiq.configure_client do |config|
  config.redis = {
    url: 'redis://multiticker.botradex.com:6380/',
    password: ENV['MULTITICKER_REDIS_PASSWORD']
  }
end

Sidekiq.configure_server do |config|
  config.redis = {
    url: 'redis://multiticker.botradex.com:6380/',
    password: ENV['MULTITICKER_REDIS_PASSWORD']
  }
end

REDIS_CONN = Redis.connect(
  url: 'redis://multiticker.botradex.com:6380/',
  password: ENV['MULTITICKER_REDIS_PASSWORD']
)

module Sinatra
  module Env
    def self.registered(app)
      app.enable :protection, :method_override
      app.disable :run, :logging, :show_exceptions, :dump_errors, :raise_errors, :sessions 
    end

  end

  register Env
end
