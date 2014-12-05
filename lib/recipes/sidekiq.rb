set_default :sidekiq_name,          "sidekiq_#{app_namespace!}"
set_default :sidekiq_cmd,           lambda { "#{bundle_bin} exec sidekiq" }
set_default :sidekiqctl_cmd,        lambda { "#{bundle_prefix} sidekiqctl" }
set_default :sidekiq_timeout,       10
set_default :sidekiq_config,        "#{config_path}/sidekiq.yml"
set_default :sidekiq_log,           "#{logs_path}/sidekiq.log"
set_default :sidekiq_pid,           "#{pids_path}/sidekiq.pid"
set_default :sidekiq_concurrency,   10
# set_default :sidekiq_start,         "(cd #{deploy_to}/#{current_path}; nohup #{sidekiq_cmd} -e #{rails_env} -C #{sidekiq_config} -P #{sidekiq_pid} >> #{sidekiq_log} 2>&1 </dev/null &)"
set_default :sidekiq_start,         "#{sidekiq_cmd} -e #{rails_env} -C #{sidekiq_config} -P #{sidekiq_pid} >> #{sidekiq_log}"
set_default :sidekiq_upstart,       "#{upstart_path!}/#{sidekiq_name}.conf"
# set_default :sidekiq_stop,          "(cd #{deploy_to}/#{current_path} && #{sidekiqctl_cmd} stop #{sidekiq_pid} #{sidekiq_timeout})"

namespace :sidekiq do


  desc "Create configuration and other files"
  task :setup do
    on roles(:sidekiq) do
      template "sidekiq.yml.erb", sidekiq_config
      info %["Be sure to edit #{sidekiq_config}."]
      template "upstart/sidekiq.conf.erb", "/tmp/sidekiq_conf"
      execute :sudo, :mv, "/tmp/sidekiq_conf", "#{sidekiq_upstart}"
    end
  end

  # %w[quiet].each do |command|
  #   desc "#{command.capitalize} sidekiq"
  #   task command do
  #     execute %{ if [ -f #{sidekiq_pid} ]; then
  #       echo "-----> #{command.capitalize} sidekiq"
  #       #{echo_cmd %{(cd #{deploy_to}/#{current_path} && #{sidekiqctl_cmd} #{command} #{sidekiq_pid})} }
  #       fi }
  #   end
  # end

  # desc "Restart Sidekiq"
  # task :restart do
  #   invoke 'sidekiq:stop'
  #   invoke 'sidekiq:start'
  # end

  # %w[start stop].each do |command|
  #   desc "#{command.capitalize} sidekiq"
  #   task command do
  #     # need to get rid of sudo here: have to figure out how it works with upstart
  #     invoke sudo
  #     execute :sudo, "service #{sidekiq_name} #{command}"
  #     info %["#{command.capitalize} sidekiq."]
  #   end
  # end
end