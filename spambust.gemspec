# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib/', __FILE__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'spambust/version'

files      = Dir.glob('lib/**/*') + %w(LICENSE README.md CHANGELOG.md)
test_files = Dir.glob('spec/**/*')

Gem::Specification.new do |s|
  s.name              = 'spambust'
  s.version           = Spambust::VERSION
  s.authors           = ['Chirantan Mitra']
  s.email             = ['chirantan.mitra@gmail.com']
  s.homepage          = 'https://github.com/chiku/spambust'
  s.summary           = 'Sinatra form helper to reduce spams'
  s.description       = <<-EOS
Render input tags with a masked name. The original input names names are
hidden. A spam bot would fill the incorrect but visible input tags. The server
would identify this and respond appropriately.
EOS
  s.rubyforge_project = 'spambust'
  s.files             = files
  s.test_files        = test_files
  s.require_paths     = ['lib']
  s.license           = 'MIT'

  s.add_development_dependency 'sinatra'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'minitest'
  s.add_development_dependency 'rack-test'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'coveralls'
  s.add_development_dependency 'yard'
end
