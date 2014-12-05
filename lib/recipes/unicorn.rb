set_default :unicorn_name,          "unicorn_#{app_namespace!}"
set_default :unicorn_socket,        "#{sockets_path}/unicorn.sock"
set_default :unicorn_pid,           "#{pids_path}/unicorn.pid"
set_default :unicorn_config,        "#{config_path}/unicorn.rb"
set_default :unicorn_log,           "#{logs_path}/unicorn.log"
set_default :unicorn_error_log,     "#{logs_path}/unicorn.error.log"
set_default :unicorn_script,        "#{services_path!}/#{unicorn_name}"
set_default :unicorn_workers,       1
set_default :unicorn_bin,           lambda { "#{bundle_bin} exec unicorn" }
set_default :unicorn_cmd,           "cd #{deploy_to}/#{current_path} && #{unicorn_bin} -D -c #{unicorn_config} -E #{rails_env}"
set_default :unicorn_user,          user
set_default :unicorn_group,         user

namespace :unicorn do

  task(:install) {  }

  desc "Setup Unicorn initializer and app configuration"
  task :setup do
    on roles(:app) do
      template "unicorn.rb.erb", unicorn_config
      template "unicorn_init.erb", "/tmp/unicorn_init", chmod: "+x"
      execute :sudo, :mv, "/tmp/unicorn_init", "#{unicorn_script}"
      execute :sudo, "update-rc.d -f #{unicorn_name} defaults"
    end
  end

  %w[start stop restart].each do |command|
    desc "#{command} unicorn"
    task command do
      on roles(:app) do
        execute :service, "#{unicorn_name}", "#{command}"
      end
    end
  end
end