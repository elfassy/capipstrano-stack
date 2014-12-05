namespace :rbenv do

  desc "Install rbenv, Ruby, and the Bundler gem"
  task :install do
    on roles(:all) do
      execute :sudo, "apt-get -y install curl git-core"
      execute "curl -L https://raw.github.com/fesplugas/rbenv-installer/master/bin/rbenv-installer | bash"
      bashrc = <<-BASHRC
        if [ -d $HOME/.rbenv ]; then
          export PATH="$HOME/.rbenv/bin:$PATH"
          eval "$(rbenv init -)"
        fi
      BASHRC
      put bashrc, "/tmp/rbenvrc"
      execute "cat /tmp/rbenvrc ~/.bashrc > ~/.bashrc.tmp"
      execute "mv ~/.bashrc.tmp ~/.bashrc"
      execute %q{export PATH="$HOME/.rbenv/bin:$PATH"}
      execute %q{eval "$(rbenv init -)"}
      execute :sudo, "apt-get -y install build-essential zlib1g-dev libssl-dev libreadline-gplv2-dev"
      execute "rbenv install #{ruby_version}"
      execute "rbenv global #{ruby_version}"
      execute "gem install bundler --no-ri --no-rdoc"
      execute "rbenv rehash"
    end
  end

end
