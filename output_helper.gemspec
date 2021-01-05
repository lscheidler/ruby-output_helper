# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'output_helper/version'

Gem::Specification.new do |spec|
  spec.name          = "output_helper"
  spec.version       = OutputHelper::VERSION
  spec.authors       = ["Lars Eric Scheidler"]
  spec.email         = ["lscheidler@liventy.de"]

  spec.summary       = %q{output helpers}
  spec.description   = %q{helpers for output}
  spec.homepage      = "https://github.com/lscheidler/ruby-output_helper"
  spec.license       = "Apache-2.0"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.13"
  spec.add_development_dependency "rake", "~> 12.3"
  spec.add_development_dependency "rspec", "~> 3.8"
  spec.add_development_dependency "yard", "~> 0.9.16"
  spec.add_runtime_dependency "colorize", "~> 0.8.1"
end
