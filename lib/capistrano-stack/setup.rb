namespace :deploy do
  desc "Install Server Stack Services"
    task :install do
      invoke 'libs'

      server_stack.each do |service|
        invoke "#{service}:install"
      end
    end


    desc "#{action.capitalize} Server Stack Services"
    task :setup do
      invoke "create_paths"
      invoke "create_secrets"

      server_stack.each do |service|
        invoke "#{service}:#{action}"
      end
    end
  end

  desc 'Create config files'
  task :create_secrets do
    template "secrets.yml.erb"
    warn %["Be sure to edit 'shared/config/secrets.yml'."]
  end

  desc "Install some important libs"
  task :libs do
    on roles(:all) do
      execute :sudo, "apt-get -y install curl libcurl3 libcurl3-dev"
      execute :sudo, "apt-get -y install libxml2 libxml2-dev libxslt-dev"
      execute :sudo, "apt-get -y install build-essential libssl-dev libcurl4-openssl-dev libreadline-dev libyaml-dev"
    end
  end


  desc 'Create extra paths for shared configs, pids, sockets, etc.'
  task :create_extra_paths do
    info '"Create configs path"'
    execute :mkdir, "-p #{shared_path}/config"

    info '"Create shared paths"'
    shared_paths.each do |p|
      execute :mkdir, "-p #{deploy_to}/#{shared_path}/#{p}" unless p.include?(".")
    end

    shared_dirs = shared_paths.map { |file| File.dirname("#{deploy_to}/#{shared_path}/#{file}") }.uniq
    shared_dirs.map do |dir|
      execute %{mkdir -p "#{dir}"}
    end

    info '"Create PID and Sockets paths"'
    execute :mkdir, "-p #{pids_path} && chown #{user}:#{group} #{pids_path} && chmod +rw #{pids_path}"
    execute :mkdir, "-p #{sockets_path} && chown #{user}:#{group} #{sockets_path} && chmod +rw #{sockets_path}"

  end
end




