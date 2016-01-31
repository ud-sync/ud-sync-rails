# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ud_sync/version'

Gem::Specification.new do |spec|
  spec.name          = "ud_sync"
  spec.version       = UdSync::VERSION
  spec.authors       = ["Alexandre de Oliveira"]
  spec.email         = ["chavedomundo@gmail.com"]

  spec.summary       = ""
  spec.description   = ""
  spec.homepage      = "https://github.com/kurko/ud-sync-rails"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "database_cleaner"
  spec.add_dependency "rails", ">=4.2"
  spec.add_dependency "railties", ">=4.2"
end
