require "rack/test"
require "sinatra/base"

begin
  require "simplecov"
  SimpleCov.start do
    add_filter "/spec|test|vendor/"
  end
rescue LoadError
  puts "\nPlease install simplecov to generate coverage report!\n\n"
end

gem "minitest"
require "minitest/autorun"

ENV["environment"] = "test"
