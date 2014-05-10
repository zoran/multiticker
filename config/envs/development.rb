require 'sinatra/base'
require 'redis'
require 'sidekiq'
require 'sidekiq/web'

# Local Redis
REDIS_CONN = Redis.new

Sidekiq.configure_client do |config|
  config.redis = { url: 'redis://localhost' }
end

Sidekiq.configure_server do |config|
  config.redis = { url: 'redis://localhost' }
end

module Sinatra
  module Env

    def self.registered(app)
      app.enable :logging, :dump_errors, :raise_errors, :protection
      app.disable :run, :show_exceptions, :sessions
    end

  end

  register Env
end
