namespace :imagemagick do

  desc "Install the latest release of Imagemagick"
  task :install do
    on roles(:app) do
      execute :sudo, "apt-get install imagemagick libmagickwand-dev -y"
    end
  end

end