#!/usr/bin/env ruby

# demo_app.rb
#
# Author::    Chirantan Mitra
# Copyright:: Copyright (c) 2013-2016. All rights reserved
# License::   MIT

require 'tilt/erb'
require 'sinatra'

require_relative '../../lib/spambust/form_helpers'

module Spambust
  class TestApp < Sinatra::Base
    helpers Spambust::FormHelpers

    class << self
      def start_app
        run!
      end

      def direct_script_execution?
        app_file == $PROGRAM_NAME
      end
    end

    get '/' do
      erb :index, locals: { result: '...' }
    end

    post '/' do
      result = valid?("user", params) ? "Users is #{decrypt("user", params)}" : "Faking is bad"
      erb :index, :locals => { :result => result }
    end

    start_app if direct_script_execution? && ENV['environment'] != 'test'
  end
end
