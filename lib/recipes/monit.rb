set_default :monit_config_path,     "/etc/monit/conf.d"
set_default :monit_http_port,       2812
set_default :monit_http_username,   "PleaseChangeMe_monit"
set_default :monit_http_password,   "PleaseChangeMe"

namespace :monit do

  desc "Install Monit"
  task :install do
    on roles(:all) do
      info %{"Installing Monit..."}
      execute :sudo, "apt-get -y install monit"
    end
  end

  desc "Setup all Monit configuration"
  task :setup do
    
    if monitored.any?
      info '"Create Monit dir"'
      execute :mkdir, "-p #{config_path}/monit && chown #{user}:#{group} #{config_path}/monit && chmod +rw #{config_path}/monit"
      monitored.each do |p|
        path = "#{config_path}/monit/#{p}"
        execute :mkdir, "-p #{path} && chown #{user}:#{group} #{path} && chmod +rw #{path}"
      end

      info %{"Setting up Monit..."}
      monitored.each do |daemon|
        case daemon 
        when "memcached", "elasticsearch", "sidekiq"
          on roles(daemon) do
            invoke "monit:#{daemon}"
          end
        else
          on roles(:app) do
            invoke "monit:#{daemon}"
          end
        end
      end
      invoke 'monit:syntax'
      invoke 'monit:restart'
    else
      info %{"Skiping monit - nothing is set for monitoring..."}
    end
  end

  task(:nginx) { monit_config "nginx" }
  task(:postgresql) { monit_config "postgresql" }
  task(:redis) { monit_config "redis" }
  task(:memcached) { monit_config "memcached" }
  task(:puma) { monit_config "puma", "#{puma_name}" }
  task(:unicorn) { monit_config "unicorn", "#{unicorn_name}" }
  task(:sidekiq) { monit_config "sidekiq", "#{sidekiq_name}" }
  task(:private_pub) { monit_config "private_pub", "#{private_pub_name}" }

  %w[start stop restart syntax reload].each do |command|
    desc "Run Monit #{command} script"
    task command do
      on roles(:all) do
        info %{"Monit #{command}"}
        execute :sudo, "service monit #{command}"
      end
    end
  end
end

def monit_config(original_name, destination_name = nil)
  destination_name ||= origin_name
  path ||= monit_config_path
  destination = "#{path}/#{destination_name}"
  template "monit/#{original_name}.erb", "#{config_path}/monit/#{original_name}"
  execute %{sudo ln -fs "#{config_path}/monit/#{original_name}" "#{destination}"}

  # execute :sudo, "mv /tmp/monit_#{original_name} #{destination}"
  # execute :sudo, "chown root #{destination}"
  # execute :sudo, "chmod 600 #{destination}"
end