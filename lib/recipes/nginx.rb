set_default :nginx_pid,             "/var/run/nginx.pid"
set_default :nginx_config,          "#{nginx_path!}/sites-available/#{app_namespace!}.conf"
set_default :nginx_config_e,        "#{nginx_path!}/sites-enabled/#{app_namespace!}.conf"

namespace :nginx do

  desc "Install latest stable release of nginx"
  task :install do
    on roles(:web) do
      execute :sudo, "add-apt-repository ppa:nginx/stable --yes"
      execute :sudo, "apt-get -y update"
      execute :sudo, "apt-get -y install nginx"
    end
  end

  desc "Upload and update (link) all nginx config file"
  task :setup do 
    upload
    link
    reload
  end

  desc "Symlink config file"
  task :link do
    on roles(:web) do
      info %{"Symlink nginx config file"}
      execute %{sudo ln -fs "#{config_path}/nginx.conf" "#{nginx_config}"}
      check_symlink nginx_config
      execute %{sudo ln -fs "#{config_path}/nginx.conf" "#{nginx_config_e}"}
      check_symlink nginx_config_e
    end
  end

  desc "Parses nginx config file and uploads it to server"
  task :upload do
    on roles(:web) do
      template 'nginx.conf.erb', "#{config_path}/nginx.conf"
    end
  end

  desc "Parses config file and outputs it to STDOUT (local task)"
  task :parse do
    run_locally do
      puts "#"*80
      puts "# nginx.conf"
      puts "#"*80
      puts erb("#{config_templates_path}/nginx.conf.erb")
    end
  end

  %w(stop start restart reload status).each do |action|
    desc "#{action.capitalize} Nginx"
    task action.to_sym do
      on roles(:web) do
        info %{"#{action.capitalize} Nginx"}
        execute "sudo service nginx #{action}"
      end
    end
  end
end