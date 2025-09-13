# frozen_string_literal: true

require 'rspec/core/rake_task'

# Default task
task default: :spec

# RSpec test task
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.rspec_opts = ['--format', 'documentation', '--color']
end

# Separate tasks for different test types
namespace :spec do
  desc 'Run plugin tests'
  RSpec::Core::RakeTask.new(:plugins) do |t|
    t.pattern = 'spec/plugins/*_spec.rb'
    t.rspec_opts = ['--format', 'documentation', '--color']
  end

  desc 'Run integration tests'
  RSpec::Core::RakeTask.new(:integration) do |t|
    t.pattern = 'spec/integration/*_spec.rb'
    t.rspec_opts = ['--format', 'documentation', '--color']
  end
end

desc 'Build gem'
task :build do
  system 'gem build tessellate.gemspec'
end

desc 'Clean up build artifacts'
task :clean do
  system 'rm -f *.gem'
  system 'rm -rf spec/examples.txt'
end

desc 'Run tests and build gem'
task release: [:spec, :build]