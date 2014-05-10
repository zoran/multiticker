require 'yaml'

# Basic database tasks which doesn't rely on an interface like ActiveRecord
namespace :db do

  require_relative '../../../config/base'

  if Bittracktor::MultiTicker::Base.db
    database    = Bittracktor::MultiTicker::Base.db
    @db_config  = Bittracktor::MultiTicker::Base.db_config
    @db_configs = Bittracktor::MultiTicker::Base.db_configs

    desc 'Ping database'
    task :ping do
      ping = PG::Connection.ping(
        host: @db_config['host'],
        port: @db_config['port'],
        dbname: 'postgres'
      )

      case ping
        when 0; puts "server is accepting connections\n\n"
        when 1; puts "server is alive but rejecting connections\n\n"
        when 2; puts "could not establish connection\n\n"
        when 3; puts "connection not attempted (bad params)\n\n"
      end
    end

    namespace :create do
      desc 'Create all local databases (development, test, etc.) defined in database.yml'
      task :all  do
        puts "\n===> Creating all databases: #{db_names.join(', ')}"

        @db_configs.each do |env, conf|
          next unless conf['database'] # skip global, etc.
          local_database?(conf) { create_db(conf) } # Local databases only
        end

        puts "<=== db:create:all executed\n\n"
      end
    end

    desc 'Create local database for current environment'
    task :create do
      puts "\n===> Creating database '#{@db_config['database']}'"
      create_db(@db_config)
      puts "<=== db:create executed\n\n"
    end

    namespace :drop do
      desc 'Drop all local databases defined in database.yml'
      task :all do
        puts "\n===> Drop all databases: #{db_names.join(', ')}"

        @db_configs.each do |env, conf|
          next unless conf['database'] # skip global, etc.
          local_database?(conf) { drop_db(conf) } # Local databases only
        end

        puts "<=== db:create:all executed\n\n"
      end
    end

    desc 'Drop local database for current environment'
    task :drop do
      puts "\n===> Dropping database '#{@db_config['database']}'"
      drop_db(@db_config)
      puts "<=== db:drop executed\n\n"
    end

    def create_db(conf)
      begin
        stat = system(
          'createdb',
          '-E', conf['encoding'],
          '-h', conf['host'],
          '-p', conf['port'].to_s,
          '-U', conf['username'],
          conf['database']
        )

        puts "* Created a new database '#{conf['database']}'" if stat
      rescue
        $stderr.puts $!, *($!.backtrace)
        $stderr.puts "Couldn't create database #{conf['database']}"
      end

      # Set search_path for the new database if there are more than the default 'public'
      if conf['search_path'].strip && conf['search_path'].strip != 'public'
        begin
          search_path = conf['search_path']
          conn = connect(conf)
          alter = conn.exec("ALTER DATABASE #{conf['database']} SET search_path = #{search_path}")
          puts "* Changed 'search_path' to '#{search_path}' for '#{conf['database']}'"
        rescue
          $stderr.puts $!, *($!.backtrace)
          $stderr.puts "Couldn't create database for #{conf.inspect}"
        end
      end
    end

    def drop_db(conf)
      begin
        # Drop active connections first
        sql = " REVOKE CONNECT ON DATABASE #{ conf['database'] } FROM public;
            ALTER DATABASE #{ conf['database'] } CONNECTION LIMIT 0;
            SELECT pg_terminate_backend(pid)
              FROM pg_stat_activity
              WHERE pid <> pg_backend_pid()
              AND datname = '#{ conf['database'] }';"

        system(
            'psql',
            '-h', conf['host'],
            '-p', conf['port'].to_s,
            '-U', conf['username'],
            '-c', sql,
            conf['database']
        )

        # Drop database
        stat = system(
          'dropdb',
          '-h', conf['host'],
          '-p', conf['port'].to_s,
          '-U', conf['username'],
          conf['database']
        )

        puts "#{conf['database']} successfully dropped." if stat
      rescue
        $stderr.puts $!, *($!.backtrace)
        $stderr.puts "Couldn't drop database #{conf['database']}"
      end
    end

  private

    def db_names
      @db_configs.collect { |env, conf| conf['database'] }.compact!
    end

    def local_database?(conf, &block)
      if %w( 127.0.0.1 localhost ).include?(conf['host']) || conf['host'].blank?
        yield
      else
        puts "This task only modifies local databases. #{ conf['database'] } is on a remote host."
      end
    end

    def connect(conf)
      PG::Connection.open(
        host: conf['host'],
        port: conf['port'],
        user: conf['username'],
        dbname: conf['database']
      )
    end
  end

end
