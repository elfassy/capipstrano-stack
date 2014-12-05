
# set_default :private_pub_name,      "private_pub_#{app_namespace}"
# set_default :private_pub_cmd,       lambda { "#{bundle_prefix} rackup private_pub.ru" }
# set_default :private_pub_pid,       "#{pids_path}/private_pub.pid"
# set_default :private_pub_config,    "#{config_path}/private_pub.yml"
# set_default :private_pub_log,       "#{logs_path}/private_pub.log"
# set_default :private_pub_server,    "puma"

# namespace :private_pub do

#   task(:install) {  }

#   desc "Setup Private Pub configuration"
#   task :setup => [:upload]

#   desc "Create configuration and other files"
#   task :upload do
#     template "private_pub.yml.erb", private_pub_config
#     info %["Be sure to edit #{private_pub_config}."]
#   end

#   desc "Stop Private Pub"
#   task :stop do
#     execute %[ if [ -f #{private_pub_pid} ]; then
#       echo "-----> Stop Private Pub"
#       kill -s QUIT `cat #{private_pub_pid}` || true
#       fi ]
#   end

#   desc "Start Private Pub"
#   task :start do
#     execute %{
#       echo "-----> Start Private Pub"
#       #{echo_cmd %[(cd #{deploy_to}/#{current_path}; #{private_pub_cmd} -s #{private_pub_server} -E #{rails_env} -P #{private_pub_pid} >> #{private_pub_log} 2>&1 </dev/null &) ] }
#       }
#   end

#   desc "Restart Private Pub"
#   task :restart do
#     invoke 'private_pub:stop'
#     invoke 'private_pub:start'
#   end
# end