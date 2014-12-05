# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano-stack/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-stack"
  spec.version       = Capistrano::Stack::VERSION
  spec.authors       = ["Igor Davydov"]
  spec.email         = ["iskiche@gmail.com"]
  spec.description   = %q{Easy deploy of rails app stack with capistrano on ubuntu servers}
  spec.summary       = %q{Capistrano3 + stack}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rake"
  spec.add_dependency 'capistrano-rails',   '~> 1.1'
  spec.add_dependency 'capistrano-bundler', '~> 1.1'
  spec.add_dependency 'capistrano-chruby'
  spec.add_development_dependency "bundler", "~> 1.3"
end
