# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'clint_eastwood/version'

Gem::Specification.new do |spec|
  spec.name          = "clint_eastwood"
  spec.version       = ClintEastwood::VERSION
  spec.authors       = ["Joey Lorich"]
  spec.email         = ["joey@cloudspace.com"]
  spec.summary       = %q{The Cloudspace ruby linter}
  spec.description   = %q{A simple way to run a series of linting tools with default configurations matching cloudspace's best practices}
  spec.homepage      = "https://github.com/cloudspace/clint_eastwood"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  
  spec.add_dependency 'reek', '~> 1.3.7'
  spec.add_dependency 'rubocop', '~> 0.28.0'
  spec.add_dependency 'thor', '~> 0.19.1'
  spec.add_dependency 'rails_best_practices', '~> 1.15.4'

  spec.executables = ['clint']
end
