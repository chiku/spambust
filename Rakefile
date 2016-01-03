gem 'rdoc'

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rubocop/rake_task'
require 'rdoc/task'

Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
end

RuboCop::RakeTask.new(:lint)

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.main = 'README.md'
  rdoc.rdoc_files.include('README.md', 'CHANGELOG.md', 'lib/**/*.rb')
end

task test: :spec
task default: [:lint, :test, :rdoc]
