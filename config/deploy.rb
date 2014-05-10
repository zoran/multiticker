set :application, 'multiticker'
set :repo_url, 'git@github.com:zoran/multiticker.git'
set :git_enable_submodules, 1
set :scm, :git
set :format, :pretty
set :keep_releases, 7
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets}
set :linked_files, %w{config/database.yml config/sidekiq.yml config/puma.rb}
set :copy_cache, true
set :git_shallow_clone, 1

set :ssh_options, {
  forward_agent: true,
  keys: [File.join('~', '.ssh', 'multiticker')]
}

SSHKit.config.command_map[:rake] = 'bundle exec rake'

# Bunudler
set :bundle_jobs, 4

# Puma
set :puma_threads,            [0, 16]
set :puma_workers,            1
set :puma_rackup,             -> {File.join(current_path, 'config.ru')}
set :puma_state,              -> {File.join(shared_path, 'tmp', 'pids', 'puma.state')}
set :puma_pid,                -> {File.join(shared_path, 'tmp', 'pids', 'puma.pid')}
set :puma_bind,               -> {File.join('unix://', shared_path, 'tmp', 'sockets', 'puma.sock')}
set :puma_conf,               -> {File.join(shared_path, 'config', 'puma.rb')}
set :puma_access_log,         -> {File.join(shared_path, 'log', 'puma_access.log')}
set :puma_error_log,          -> {File.join(shared_path, 'log', 'puma_error.log')}
set :puma_init_active_record, false
set :puma_preload_app,        true
set :puma_jungle_conf,        '/etc/puma.conf'

# Sidekiq
set :sidekiq_default_hooks,   true
set :sidekiq_env,             -> {fetch(:rack_env)}
set :sidekiq_timeout,         10
set :sidekiq_role,            -> {:app}
set :sidekiq_tag,             -> {fetch(:application)}
set :sidekiq_pid,             -> {File.join(shared_path, 'tmp','pids', 'sidekiq.pid')}
set :sidekiq_log,             -> {File.join('/', 'dev', 'null')}
set :sidekiq_require,         -> {File.join(release_path, 'app.rb')}
set :sidekiq_processes,       1
set :sidekiq_options,         -> {"--config #{current_path}/config/sidekiq.yml"}

namespace :deploy do
  after 'symlink:release', 'db:migrate'
end
