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
Render input tags with a masked name. The input tags with proper tags are hidden.
We expect a spam bot to fill the incorrect input tags. Our server would pick the spam bot
and respond accordingly.
EOS
  s.rubyforge_project        = "spambust"
  s.files                    = Dir.glob("{lib,bin,test}/**/*") + %w(LICENSE README.md)
  s.test_files               = Dir.glob("{spec}/**/*")
  s.require_paths            = ["lib"]

  s.add_development_dependency "sinatra"
  s.add_development_dependency "rake"
  s.add_development_dependency "minitest"
end
