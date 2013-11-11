require "bundler/setup"
require "sinatra"
require "digest/md5"

require_relative "lib/spambust"

module Spambust
  class App < Sinatra::Base
    helpers Spambust::FormHelpers

    class << self
      def start_app
        run!
      end

      def direct_script_execution?
        app_file == $0
      end
    end

    get "/" do
      erb :index
    end

    post '/' do
      @result = valid?("user", params) ? "Users is #{decrypt("user", params)}" : "Faking is bad"
      erb :index
    end

    start_app if direct_script_execution?
  end
end
