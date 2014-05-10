set :rack_env, 'production'
set :rails_env, fetch(:rack_env)
set :stage, :production
set :branch, ENV['REVISION'] || ENV['BRANCH_NAME'] || 'master'
set :log_level, :info
set :deploy_user, 'multiticker'
set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"
set :deploy_to, "/home/#{fetch(:deploy_user)}/apps/#{fetch(:full_app_name)}"
set :server_name, "multiticker.botradex.com"

server 'multiticker.botradex.com', roles: %w{web app db}, user: fetch(:deploy_user), primary: true
