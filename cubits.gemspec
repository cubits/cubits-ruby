# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cubits/version'

Gem::Specification.new do |spec|
  spec.name          = 'cubits'
  spec.version       = Cubits::VERSION
  spec.authors       = ['Alex Kukushkin']
  spec.email         = ['alex.kukushkin@cubits.com']
  spec.summary       = 'Ruby client for Cubits Merchant API'
  spec.description   = 'Ruby client for Cubits Merchant API'
  spec.homepage      = 'https://github.com/cubits/cubits-ruby'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'http', '~> 0.8', '>= 0.8.12'
  spec.add_dependency 'hashie', '~> 3.3'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry'
end
