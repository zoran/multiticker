namespace :db do

  require "sequel"
  require_relative "../../../config/base"

  if Bittracktor::MultiTicker::Base.db
    database = Bittracktor::MultiTicker::Base.db

    database.disconnect
    Sequel.extension :migration

    desc "Prints current schema version"
    task :version do
      version = if database.tables.include?(:schema_info)
        database[:schema_info].first[:version]
      end || 0

      puts "Schema Version: #{version}"
    end

    desc "Perform migration up to latest migration available"
    task :migrate do
      Sequel::Migrator.run(database, "./db/migrate")
      Rake::Task['db:version'].execute
    end

    desc "Perform rollback to specified target or full rollback as default"
    task :rollback, :target do |t, args|
      args.with_defaults(:target => 0)

      Sequel::Migrator.run(database, "./db/migrate", :target => args[:target].to_i)
      Rake::Task['db:version'].execute
    end

    desc "Perform migration reset (full rollback and migration)"
    task :reset do
      Sequel::Migrator.run(database, "./db/migrate", :target => 0)
      Sequel::Migrator.run(database, "./db/migrate")
      Rake::Task['db:version'].execute
    end

    desc "Create a migration at ./db/migrate/{NAME}"
    task :create_migration do
      name = ENV['NAME']
      abort("no NAME specified. use `rake db:create_migration NAME=create_users`") if !name

      migrations_dir = File.join("db", "migrate")
      version = ENV["VERSION"] || Time.now.utc.strftime("%Y%m%d%H%M%S")
      filename = "#{version}_#{name}.rb"
      migration_name = name.gsub(/_(.)/) { $1.upcase }.gsub(/^(.)/) { $1.upcase }

      FileUtils.mkdir_p(migrations_dir)

      open(File.join(migrations_dir, filename), 'w') do |f|
        f << (<<-EOS).gsub("      ", "")
        Sequel.migration do
          change do
            create_table(:#{name}) do
            #primary_key :id
            #String :name, null: false
            end
          end
        end
        EOS
      end

      puts "New migration created at #{migrations_dir}/#{filename}"
    end
  end

end
