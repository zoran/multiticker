require 'redis'
require 'sidekiq'
require 'sidekiq/web'
require 'sinatra/base'

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
      app.enable :dump_errors, :raise_errors, :protection, :method_override
      app.disable :run, :logging, :show_exceptions, :sessions
    end

  end

  register Env
end
