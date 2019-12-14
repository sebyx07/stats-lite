# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

get_gem_file = -> { Dir["pkg/*"].first }

desc "test"
task :test do
  sh "gem uninstall stats_lite -a -x"
  sh "rm #{get_gem_file.call} -f"
  sh "rake build"
  sh "gem install #{get_gem_file.call}"
end

desc "integration"
task "integration" do
  sh "rake test"
  sh "stats-lite ./integration_test/config.rb"
end


desc "deploy"
task "deploy" do
  sh "rm #{get_gem_file.call} -f"
  sh "rake build"
  sh "gem push #{get_gem_file.call}"
end
