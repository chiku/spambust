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

task test: :spec
task default: [:lint, :test, :doc]
