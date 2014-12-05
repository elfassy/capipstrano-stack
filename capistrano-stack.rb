require "capistrano-stack/version"
require 'capistrano-stack/defaults'
require 'capistrano-stack/base'
require 'capistrano-stack/setup'

Dir['config/servers/*.rb'].each { |f| load f }
Dir[File.dirname(__FILE__) + '/recipes/*.rb'].each {|file| require file }