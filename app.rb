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

    def decrypt(lookup, global)
      fake = global[lookup] || {}
      hashed_lookup = Digest::MD5.hexdigest(lookup)
      subset = global[hashed_lookup] || {}

      fake.reduce({}) do |real, (key, value)|
        real[key] = subset[Digest::MD5.hexdigest(key)]
        real
      end
    end

    def valid?(lookup, global)
      fake = global[lookup] || {}

      fake.reduce(true) do |valid, (key, value)|
        valid && (value == nil || value == "")
      end
    end

    get "/" do
      erb :index
    end

    post '/users' do
      if valid?("user", params)
        user = decrypt("user", params)
        @result = "Users is #{user}"
      else
        @result = "Faking is bad"
      end

      erb :index
    end

    start_app if direct_script_execution?
  end
end
