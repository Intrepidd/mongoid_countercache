# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid_countercache/version'

Gem::Specification.new do |spec|
  spec.name          = "mongoid_countercache"
  spec.version       = MongoidCounterCache::VERSION
  spec.authors       = ["Adrien Siami"]
  spec.email         = ["adrien@siami.fr"]
  spec.description   = "A simple counter cache implemented for mongoid, with neat additions such as lambda evaluation"
  spec.summary       = "A simple counter cache implemented for mongoid, with neat additions such as lambda evaluation"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'mongoid', '>= 3.0.0',  '<= 4.0.0'
  spec.add_dependency("rake")

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
