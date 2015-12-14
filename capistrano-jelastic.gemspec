# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano/jelastic/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-jelastic"
  spec.version       = Capistrano::Jelastic::VERSION
  spec.authors       = ["Gerardo Navarro Suarez"]
  spec.email         = ["gerardo.navarro@edeka.de"]

  spec.summary       = %q{BLABLA}
  spec.description   = %q{BLABLA}
  spec.homepage      = 'http://mygemserver.com'
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "bundler", "~> 1.10"
  spec.add_dependency 'capistrano', '~> 3.1'
  # Because rvm is used on jelastic to handle ruby versions
  spec.add_dependency 'capistrano-rvm'
  spec.add_dependency 'capistrano-rails'
  spec.add_dependency 'capistrano-bundler'
end
