require 'yaml'
require 'pg'
require 'sequel'

Bittracktor::MultiTicker::Base.configure do |app|
  app.set :db_conf_file, File.join(app.config_dir, 'database.yml')
  app.set :db_configs, YAML.load_file(app.db_conf_file)
  app.set :db_config, app.db_configs[app.environment.to_s]

  # Establish connection only if the DB accepts connections
  pong = PG::Connection.ping(
    host: app.db_config['host'],
    port: app.db_config['port'],
    dbname: 'postgres'
  )

  if pong == 0
    app.set :db, Sequel.connect(
      adapter: app.db_config['adapter'],
      host: app.db_config['host'],
      port: app.db_config['port'],
      pool: app.db_config['pool'],
      search_path: app.db_config['search_path'],
      template: app.db_config['template'],
      username: app.db_config['username'],
      password: app.db_config['password'],
      encoding: app.db_config['encoding'],
      database: app.db_config['database']
    )
  end
end
