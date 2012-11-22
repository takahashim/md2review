# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redcarpet-review/version'

Gem::Specification.new do |gem|
  gem.name          = "redcarpet-review"
  gem.version       = Redcarpet::Review::VERSION
  gem.authors       = ["takahashim"]
  gem.email         = ["takahashimm@gmail.com"]
  gem.description   = %q{redcarpet extension to generate ReVIEW format}
  gem.summary       = %q{redcarpet extension to generate ReVIEW format}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
