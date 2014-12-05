namespace :es do

  desc "Install the latest release of ElasticSearch"
  task :install do
    on roles(:elasticsearch) do
      info %{"Installing ElasticSearch..."}
      execute :sudo, "apt-get install openjdk-7-jre -y"
      execute :wget, "https://github.com/downloads/elasticsearch/elasticsearch/elasticsearch-0.19.1.tar.gz -O elasticsearch.tar.gz"
      execute :tar, "-xf", "elasticsearch.tar.gz"
      execute :rm, "elasticsearch.tar.gz"
      execute :sudo, "mv elasticsearch-* elasticsearch"
      execute :sudo, "mv elasticsearch /usr/local/share"

      execute :curl, "-L http://github.com/elasticsearch/elasticsearch-servicewrapper/tarball/master | tar -xz"
      execute :mv, "*servicewrapper*/service", "/usr/local/share/elasticsearch/bin/"
      execute :rm, "-Rf", "*servicewrapper*"
      execute :sudo, "/usr/local/share/elasticsearch/bin/service/elasticsearch install"
      execute :sudo, "ln -s `readlink -f /usr/local/share/elasticsearch/bin/service/elasticsearch` /usr/local/bin/rcelasticsearch"
    end
  end


  %w[start stop restart].each do |command|
    desc "#{command} elasticsearch"
    task command do
      on roles(:elasticsearch) do
        execute :sudo, "service elasticsearch #{command}"
      end
    end
  end

end