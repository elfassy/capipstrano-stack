namespace :rails do

  task :log do
    on roles(:all) do
      execute 'echo "Contents of the log file are as follows:"'
      execute "tail -f #{logs_path}/#{rails_env}.log"
    end
  end
end



# desc "Open the rails console on one of the remote servers"
#  task :console, :roles => :app do
#    execute %{ssh #{domain} -t "#{default_shell} -c 'cd #{current_path} && bundle exec rails c #{rails_env}'"}
#  end

#  desc "remote rake task"
#  task :rake do
#    run "cd #{deploy_to}/current; RAILS_ENV=#{rails_env} rake #{ENV['TASK']}"
#  end