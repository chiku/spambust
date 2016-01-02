# spec_helper.rb
#
# Author::    Chirantan Mitra
# Copyright:: Copyright (c) 2013-2016. All rights reserved
# License::   MIT

gem 'minitest'

require 'minitest/autorun'
require 'minitest/spec'
require 'rack/test'
require 'sinatra/base'

ENV['environment'] = 'test'

begin
  require 'simplecov'
  require 'coveralls'
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new [
    SimpleCov::Formatter::HTMLFormatter,
    Coveralls::SimpleCov::Formatter
  ]
  SimpleCov.start do
    add_filter '/spec|test|vendor/'
  end
rescue LoadError
  puts "\nPlease install simplecov & coveralls to generate coverage report!\n\n"
end
