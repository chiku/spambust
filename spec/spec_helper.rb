require "rack/test"
require "sinatra/base"

gem "minitest"
require "minitest/autorun"

ENV["environment"] = "test"
