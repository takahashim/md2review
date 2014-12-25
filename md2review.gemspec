# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'md2review/version'

Gem::Specification.new do |gem|
  gem.name          = "md2review"
  gem.version       = MD2ReVIEW::VERSION
  gem.authors       = ["takahashim"]
  gem.email         = ["takahashimm@gmail.com"]
  gem.description   = %q{a converter from Markdown to Re:VIEW. It uses redcarpet.}
  gem.summary       = %q{a converter from Markdown to Re:VIEW}
  gem.homepage      = 'https://github.com/takahashim/md2review'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency('redcarpet', '>2.0.0')
  gem.add_development_dependency "rake"
  gem.add_development_dependency "test-unit"
end
