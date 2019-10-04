# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc "test"
task :test do
  sh "gem uninstall stats_lite -a -x"
  sh "rm pkg/*"
  sh "rake build"
  sh "gem install pkg/*"
end

desc "integration"
task "integration" do
  sh "rake test"
  sh "cd integration_test && stats-lite"
end
