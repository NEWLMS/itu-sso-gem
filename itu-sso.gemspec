# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'itu/sso/version'

Gem::Specification.new do |spec|
  spec.name          = "itu-sso"
  spec.version       = ITU::SSO::VERSION
  spec.authors       = ["Willian Fernandes"]
  spec.email         = ["wfernandes@itu.edu"]
  spec.summary       = %q{A simple interface to comunicate with ITU-SSO's endpoint.}
  spec.description   = spec.summary

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rails"
  spec.add_development_dependency "mysql2"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"

  spec.add_dependency "faraday"
end
