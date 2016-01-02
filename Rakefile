gem 'rdoc'

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'rdoc/task'

Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
end


RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.main = ' README.md'
  rdoc.rdoc_files.include('README.md', 'lib/**/*.rb')
end

task test: :spec
task default: [:test, :rdoc]
