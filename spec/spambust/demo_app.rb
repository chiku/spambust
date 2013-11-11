require "sinatra"
require File.expand_path "../../lib/spambust/form_helpers", File.dirname(__FILE__)

module Spambust
  class TestApp < Sinatra::Base
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
      erb :index, :locals => { :result => "..." }
    end

    post '/' do
      result = valid?("user", params) ? "Users is #{decrypt("user", params)}" : "Faking is bad"
      erb :index, :locals => { :result => result }
    end

    start_app if direct_script_execution? && ENV["environment"] != "test"
  end
end
