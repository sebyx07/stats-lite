# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "stats_lite/version"

Gem::Specification.new do |spec|
  spec.name          = "stats_lite"
  spec.version       = StatsLite::VERSION
  spec.authors       = ["sebi"]
  spec.email         = ["sebyx07.pro@gmail.com"]

  spec.summary       = "Simple web server to get linux system information. Rails compatible engine"
  spec.description   = %{ Get system information for linux hosts. Standalone or rails engine }
  spec.homepage      = "https://github.com/sebyx07/stats-lite"
  spec.license       = "MIT"

  spec.metadata["allowed_push_host"] = ""

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path("..", __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = "stats-lite"
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop-rails_config", "~> 0.7.2"

  spec.add_dependency "rack", ">= 2.0.0", "< 3.0.0"
  spec.add_dependency "puma", ">= 4.0.0", "< 5.0.0"
  spec.add_dependency "sinatra", ">= 2.0.0", "< 3.0.0"
  spec.add_dependency "vidibus-sysinfo", "~> 1.2.0"
  spec.add_dependency "filewatcher", "~> 1.1.1"
end
