namespace :redis do

  desc "Install the latest release of Redis"
  task :install do
    on roles(:redis) do
      info %{"Installing Redis..."}
      execute :sudo, "add-apt-repository -y ppa:chris-lea/redis-server --yes"
      execute :sudo, "apt-get -y update"
      execute :sudo, "apt-get -y install redis-server"
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command} redis"
    task command do
      on roles(:redis) do
        execute :sudo, :service, "redis", "#{command}"
      end
    end
  end

end