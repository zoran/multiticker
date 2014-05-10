require 'capistrano/setup'
require 'capistrano/deploy'
require 'capistrano/rvm'
require 'capistrano/bundler'
require 'capistrano/sidekiq'
require 'capistrano/puma'

Dir.glob('lib/capistrano/tasks/*.cap').each { |r| import r }
