capistrano-stack
===========

WORK IN PROGRESS

A compilation of several deploy scripts that I use for my rails apps. The stack I use is pretty standard,
but it may not suit your needs, so its not for everybody.
Current stack includes Nginx, Postgres, rbenv, Redis, Unicorn, Puma, Sidekiq, Memcached, Imagemagick, ElasticSearch, Bower and Monit.

## Installation

```
gem 'capistrano-stack', group: :development
```

Run the capistrano installer
```
bundle exec cap install
```

## Configuration

Edit your Capfile

```
require "capistrano/setup"
require "capistrano/deploy"

require "capistrano/bundler"
require "capistrano/rails/assets"
require "capistrano/rails/migrations"
require "capistrano/rvm"

Dir.glob("lib/capistrano/tasks/*.cap").each { |r| import r }
```
