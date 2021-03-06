# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'currentsh/version'

Gem::Specification.new do |spec|
  spec.name          = "currentsh"
  spec.version       = Currentsh::VERSION
  spec.authors       = ["Evan Phoenix"]
  spec.email         = ["evan@current.sh"]

  spec.summary       = %q{Integration with current.sh}
  spec.description   = %q{Use this gem to send logs to current.sh}
  spec.homepage      = "http://github.com/vektra/currentsh"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
