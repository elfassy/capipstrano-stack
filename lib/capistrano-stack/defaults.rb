
set_default :ruby_version,          "2.1.4"
set_default :services_path,         "/etc/init.d"
set_default :upstart_path,          "/etc/init"
set_default :tmp_path,              "#{deploy_to}/#{shared_path}/tmp"
set_default :sockets_path,          "#{tmp_path}/sockets"
set_default :pids_path,             "#{tmp_path}/pids"
set_default :logs_path,             "#{deploy_to}/#{shared_path}/log"
set_default :config_path,           "#{deploy_to}/#{shared_path}/config"
set_default :app_namespace,         "#{app!}_#{rails_env!}"
set_default :bundle,                "cd #{deploy_to}/#{current_path} && #{bundle_bin}"

set_default :term_mode,             :pretty

set_default :linked_dirs, ['bin', 
                           'log', 
                           'tmp/pids', 
                           'tmp/cache', 
                           'tmp/sockets', 
                           'vendor/bundle', 
                           'public/system'
                         ]

set_default :monitored,             %w(
                                      nginx
                                      postgresql
                                      redis
                                      puma
                                      sidekiq
                                      private_pub
                                      memcached
                                      )

set_default :server_stack,          %w(
                                      nginx
                                      postgresql
                                      redis
                                      rails
                                      rbenv
                                      puma
                                      sidekiq
                                      private_pub
                                      elastic_search
                                      imagemagick
                                      memcached
                                      monit
                                      bower
                                      node
                                    )


