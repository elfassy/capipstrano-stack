namespace :node do
  desc "Install the latest relase of Node.js"
  task :install do
    on roles(:app) do
      execute :sudo, "apt-get -y update"
      execute :sudo, "apt-get -y install software-properties-common python-software-properties python g++ make"
      execute :sudo, "add-apt-repository ppa:chris-lea/node.js --yes"
      execute :sudo, "apt-get -y update"
      execute :sudo, "apt-get -y install nodejs"
    end
  end

end
