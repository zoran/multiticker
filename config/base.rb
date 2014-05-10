require 'sinatra/base'
require 'sequel'

module Bittracktor
  module MultiTicker
    class Base < Sinatra::Base

      reset!

      set :environment, ENV['RACK_ENV'] || 'development'

      require_relative "envs/#{environment.to_s}"

      register Sinatra::Env

      before do
        content_type 'text/html'
        @robots = 'noindex,nofollow'
      end

      # App-specific settings
      set :root, File.expand_path('../../', __FILE__)
      set :app_file, File.join(root, 'app.rb')
      set :config_dir, File.join(root, 'config')
      set :title, 'MultiTicker'
      set :author, 'Zoran Kikic (zoran@kikic.name)'
      set :lock, true # Not sure if this really works
      set :layout, false
      set :template, false
      set :reload_templates, false
    
      # Prevent 'attack prevented by Rack::Protection::HttpOrigin' issue in development environment
      set :protection, origin_whitelist: ['chrome-extension://aejoelaoggembcahagimdiliamlcdmfm']

      # Require libs and inits
      files_to_require = [
        "#{root}/lib/**/*.{rb}",
        "#{root}/config/inits/**/*.rb",
      ]

      files_to_require.each {|path| Dir.glob(path, &method(:require))}

      # Sequel settings
      Sequel.datetime_class   = Time
      Sequel.default_timezone = :utc

      # Set rack protection
      use Rack::Protection, except: [:http_origin, :session_hijacking]
      use Rack::Protection::RemoteReferrer
      use Rack::Protection::EscapedParams
      use Rack::Protection::XSSHeader
      use Rack::Deflater
      use Rack::MethodOverride
      use Rack::Protection::AuthenticityToken # With this HTML forms must include: input name='authenticity_token' value=session[:csrf] type='hidden'

      error 400..510 do
        'An error occurred. Try your request again later.'
      end

      not_found do
        request.path
      end

      after do
        #response['X-Api-Header'] = API_VERSION
      end

    end
  end
end
