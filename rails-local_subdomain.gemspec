# coding: utf-8
# frozen_string_literal: true
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rails/local_subdomain/version'

Gem::Specification.new do |spec|
  spec.name = 'rails-local_subdomain'
  spec.version = Rails::LocalSubdomain::VERSION
  spec.authors = ['Manuel van Rijn', 'Kyle Whittington']
  spec.email = ['kyle.thomas.whittington@gmail.com']

  spec.summary = 'subdomain support in your development environment'
  spec.description = 'A Rails-specific solution to enable subdomain requests '\
                     'in a local development or test environment.'
  spec.homepage = 'https://github.com/kWhittington/rails-local_subdomain'
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop'
end
