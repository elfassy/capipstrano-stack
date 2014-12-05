namespace :bower do

  desc "Install bower with dependencies"
  task :install do
    on roles(:app) do
      info %{"Installing Bower..."}
      execute :sudo, "npm install -g bower"
    end
  end

  task(:setup) {  }

  desc "Install assets"
  task :install_assets do
    on roles(:app) do
      info %{"Installing Assets with Bower..."}
      execute "bower install"
    end
  end

end