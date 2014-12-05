set_default :puma_name,             "puma_#{app_namespace!}"
set_default :puma_cmd,              "puma"
set_default :pumactl_cmd,           "pumactl" 
set_default :puma_config,           "#{config_path}/puma.rb"
set_default :puma_pid,              "#{pids_path}/puma.pid"
set_default :puma_log,              "#{logs_path}/puma.log"
set_default :puma_error_log,        "#{logs_path}/puma.err.log"
set_default :puma_socket,           "#{sockets_path}/puma.sock"
set_default :puma_state,            "#{sockets_path}/puma.state"
set_default :puma_upstart,          "#{upstart_path}/#{puma_name}.conf"
set_default :puma_workers,          2
set_default :puma_sock              "#{sockets_path}/#{application}.sock"


namespace :puma do

  desc "Setup Puma configuration"
  task :setup do
    on roles(:app) do
      template "puma.rb.erb", puma_config
      info %["Be sure to edit #{puma_config}."]
      template "upstart/puma.conf.erb", "/tmp/puma_conf"
      execute :sudo, "mv /tmp/puma_conf #{puma_upstart}"
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command.capitalize} puma"
    task command do
      # need to get rid of sudo here: have to figure out how it works with upstart
      on roles(:app) do
        execute :sudo, "service #{puma_name} #{command}"
      end
    end
  end

  desc "Phased-restart puma"
  task :'phased-restart' do
    on roles(:app) do
      execute :bundle, "exec #{pumactl_cmd} -S #{puma_state} phased-restart"
    end
  end

end