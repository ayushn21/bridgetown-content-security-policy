# frozen_string_literal: true

require_relative "lib/bridgetown-content-security-policy/version"

Gem::Specification.new do |spec|
  spec.name          = "bridgetown-content-security-policy"
  spec.version       = BridgetownContentSecurityPolicy::VERSION
  spec.author        = "Ayush Newatia"
  spec.email         = "ayush@hey.com"
  spec.summary       = "Add a content security policy to your website using a convenient Ruby DSL"
  spec.homepage      = "https://github.com/ayushn21/bridgetown-content-security-policy"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r!^(test|script|features|frontend)/!) }
  spec.test_files    = spec.files.grep(%r!^test/!)
  spec.require_paths = ["lib"]
  spec.metadata      = {}

  spec.required_ruby_version = ">= 2.5.0"

  spec.add_dependency "bridgetown", ">= 0.15", "< 2.0"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "nokogiri", "~> 1.6"
  spec.add_development_dependency "rake", "~> 12.0"
  spec.add_development_dependency "rubocop-bridgetown", "~> 0.2"
end
