# -*- encoding: utf-8 -*-

lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require "spambust/version"

Gem::Specification.new do |s|
  s.name                     = "spambust"
  s.version                  = Spambust::VERSION
  s.authors                  = ["Chirantan Mitra"]
  s.email                    = ["chirantan.mitra@gmail.com"]
  s.homepage                 = "https://github.com/chiku/spambust"
  s.summary                  = "Sinatra form helper to reduce spams"
  s.description              = <<-EOS
Render input tags with a masked name. The input tags with proper names are hidden.
A spam bot is expected to fill the incorrect input tags. The server would indentify this and respond appropriately.
EOS
  s.rubyforge_project        = "spambust"
  s.files                    = Dir.glob("{lib,spec}/**/*") + %w(LICENSE README.md)
  s.test_files               = Dir.glob("spec/**/*")
  s.require_paths            = ["lib"]

  s.add_development_dependency "sinatra"
  s.add_development_dependency "rake"
  s.add_development_dependency "rdoc"
  s.add_development_dependency "rack-test"
  s.add_development_dependency "minitest"
end
