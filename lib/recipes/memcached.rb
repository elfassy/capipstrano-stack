set_default :memcached_pid,         "/var/run/memcached.pid"

namespace :memcached do
  desc "Install Memcached"
  task :install do
    on roles(:memcached) do
      execute :sudo, "apt-get -y install memcached"
    end
  end

  desc "Setup Memcached"
  task :setup do
    # template "memcached.erb", "/tmp/memcached.conf"
    # run "#{sudo} mv /tmp/memcached.conf /etc/memcached.conf"
    # restart
  end

  %w[start stop restart].each do |command|
    desc "#{command} Memcached"
    task command do
      on roles(:memcached) do
        execute :sudo, "service memcached #{command}"
      end
    end
  end
end