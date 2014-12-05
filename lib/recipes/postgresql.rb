set_default :psql_user,             "#{user}"
set_default :psql_database,         "#{application}"
set_default :postgresql_version,    "9.3"
set_default :postgresql_pid,        "/var/run/postgresql/#{postgresql_version}-main.pid"


namespace :postgresql do

  desc "Install the latest stable release of PostgreSQL."
  task :install do
    on roles(:db) do
      execute :sudo, "apt-get -y update"
      execute :sudo, "apt-get -y install postgresql postgresql-contrib libpq-dev"
    end
  end

  task :setup  do
    template "database.yml.erb"
    warn "Be sure to edit 'shared/config/database.yml'."
  end

  desc "Create database"
  task :create_db do
    info %{"Create database"}
    on roles(:db) do
      ask "PostgreSQL password:" do |psql_password|
        execute :sudo, %{-u postgres psql -c "create user #{psql_user} with password '#{psql_password}';"}
        execute :sudo, %{-u postgres psql -c "create database #{psql_database} owner #{psql_user};"}
      end
    end
  end

  # RYAML = <<-BASH
  # function ryaml {
  #   ruby -ryaml -e 'puts ARGV[1..-1].inject(YAML.load(File.read(ARGV[0]))) {|acc, key| acc[key] }' "$@"
  # };
  # BASH

  # desc 'Pull remote db in development'
  # task :pull do
  #   code = isolate do
  #     invoke environment
  #     execute RYAML
  #     execute "USERNAME=$(ryaml #{config_path!}/database.yml #{rails_env!} username)"
  #     execute "PASSWORD=$(ryaml #{config_path!}/database.yml #{rails_env!} password)"
  #     execute "DATABASE=$(ryaml #{config_path!}/database.yml #{rails_env!} database)"
  #     info %{"Database $DATABASE will be dumped locally"}
  #     execute "PGPASSWORD=$PASSWORD pg_dump -w -U $USERNAME $DATABASE -f #{tmp_path}/dump.sql"
  #     execute "gzip -f #{tmp_path}/dump.sql"
  #     run!
  #   end

  #   %x[scp #{user}@#{domain}:#{tmp_path}/dump.sql.gz .]
  #   %x[gunzip -f dump.sql.gz]
  #   %x[#{RYAML} psql -d $(ryaml config/database.yml development database) -f dump.sql]
  #   %x[rm dump.sql]
  # end

end
