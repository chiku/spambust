# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'
require 'yard'

Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

RuboCop::RakeTask.new(:lint)

YARD::Rake::YardocTask.new(:doc) do |t|
  t.files   = ['lib/**/*.rb']
end

desc 'Run tests for spec'
task test: :spec

task default: %i[lint test doc]
