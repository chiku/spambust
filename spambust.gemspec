# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?(lib)

require 'spambust/version'

files = Dir.glob('lib/**/*') + %w[LICENSE README.md CHANGELOG.md]
Dir.glob('spec/**/*')

Gem::Specification.new do |s|
  s.name              = 'spambust'
  s.version           = Spambust::VERSION
  s.authors           = ['Chirantan Mitra']
  s.email             = ['chirantan.mitra@gmail.com']
  s.homepage          = 'https://github.com/chiku/spambust'
  s.summary           = 'Sinatra form helper to reduce spams'
  s.description       = <<~DESCRIPTION
    Render input tags with masked names. The original input names are hidden.
    A spam bot would fill the incorrect but visible input tags. The server
    detects this and responds appropriately.
  DESCRIPTION
  s.files             = files
  s.require_paths     = ['lib']
  s.license           = 'MIT'

  s.required_ruby_version = '>= 3.2.0'

  s.metadata['rubygems_mfa_required'] = 'true'
end
