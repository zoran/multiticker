set :rack_env, 'staging'
set :rails_env, fetch(:rack_env)
set :stage, :staging
set :branch, ENV['REVISION'] || ENV['BRANCH_NAME'] || 'master'
set :log_level, :info
set :deploy_user, 'multiticker'
set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"
set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/#{fetch(:full_app_name)}"
set :server_name, "multiticker.botradex.com"

server 'multiticker.botradex.com', roles: %w{web app db}, user: fetch(:deploy_user), primary: true
