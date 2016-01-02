# form_helpers.rb
#
# Author::    Chirantan Mitra
# Copyright:: Copyright (c) 2013-2016. All rights reserved
# License::   MIT

require 'digest/md5'

module Spambust
  # This module provides form helpers for sinatra or alike DSLs/frameworks to test for spams
  #
  # Example:
  #  class TestApp < Sinatra::Base
  #    helpers Spambust::FormHelpers
  #
  #    class << self
  #      def start_app
  #        run!
  #      end
  #
  #      def direct_script_execution?
  #        app_file == $0
  #      end
  #    end
  #
  #    get '/' do
  #      erb :index, :locals => { :result => '...' }
  #    end
  #
  #    post '/' do
  #      result = valid?("user", params) ? "Users is #{decrypt("user", params)}" : "Faking is bad"
  #      erb :index, :locals => { :result => result }
  #    end
  #
  #    start_app if direct_script_execution? && ENV['environment'] != 'test'
  #  end
  #
  #  index.erb
  #
  # <html>
  # <head>
  #    <title>Sample Sinatra application</title>
  #  </head>
  #  <body>
  #    <div id="result"><%= result %></div>
  #    <form method="post" action="/">
  #      <label for="user-first-name">First name</label>
  #      <%= input ["user", "first_name"], :id => "user-first-name" %>
  #      <label for="user-last-name">Last name</label>
  #      <%= input ["user", "last_name"], :id => "user-last-name" %>
  #      <label for="user-email">Email</label>
  #      <%= input ["user", "email"], :size => 40, :id => "user-email" %>
  #      <%= submit "Create account", :id => "user-submit" %>
  #    </form>
  # </body>
  # </html>

  module FormHelpers
    # Returns obfustated input tags together with its fake input tags that are rendered off the screen
    #
    #  Use inside your templates to generate an obfuscated input field. This is the field that the server will use.
    #  If the server sees that fields with original names are filled, the server should assume it be be a spam.
    #  It also accepts options for input type and other CSS properties.
    #
    #  input(["user", "name"])
    #  # => <input type="text" name="#{user_digest}[#{name_digest}]" /><input type="text" style="position:absolute;top:-10000px;left:-10000px;" name="user[name]" />
    #
    #  input(["user", "name"], :type => "password")
    #  # => <input type="password" name="#{user_digest}[#{name_digest}]" /><input type="text" style="position:absolute;top:-10000px;left:-10000px;" name="user[name]" />
    #
    #  input(["user", "name"], :id => "name", :class => "name")
    #  # => <input type="text" name="#{user_digest}[#{name_digest}]" id="name" class="name" /><input type="text" style="position:absolute;top:-10000px;left:-10000px;" name="user[name]" class="name" />
    def input(paths, options = {})
      type               = options.delete(:type) || 'text'
      options_without_id = options.select { |key, _value| key != :id }
      others             = hash_to_options(options)
      others_without_id  = hash_to_options(options_without_id)
      digested_paths     = paths.map { |path| Digest::MD5.hexdigest(path) }
      %Q(<input type="#{type}" name="#{namify digested_paths}"#{others} /><input type="text" style="position:absolute;top:-10000px;left:-10000px;" name="#{namify paths}"#{others_without_id} />)
    end

    # Returns submit tags
    #
    #  Use inside your templates to generate a submit tag.
    #  It also accepts options for CSS properties.
    #
    #  submit('Submit')
    #  # => <input type="submit" value="Submit" />
    #
    #  submit("Submit", :id => "submit", :class => "submit")
    #  # => <input type="submit" value="Submit" id="submit" class="submit" />
    def submit(text, options = {})
      others = hash_to_options(options)
      %Q(<input type="submit" value="#{text}"#{others} />)
    end

    def namify(paths) # :nodoc:
      first = paths[0]
      rest  = paths[1..-1].reduce('') { |a, e| a << "[#{e}]" }
      "#{first}#{rest}"
    end

    # Returns decrypted hash of user submitted POST parameters
    #
    #  Use inside your application.
    #
    #  decrypt("user", params)
    def decrypt(lookup, global)
      fake = global[lookup] || {}
      hashed_lookup = Digest::MD5.hexdigest(lookup)
      subset = global[hashed_lookup] || {}

      fake.reduce({}) do |real, (key, value)|
        real[key] = subset[Digest::MD5.hexdigest(key)]
        real
      end
    end

    # Returns if any POST data was present in the fake input fields
    #
    #  Use inside your application.
    #
    #  valid?('user', params)
    def valid?(lookup, global)
      fake = global[lookup] || {}
      fake.none? { |key, value| value != "" }
    end

    def hash_to_options(hash) # :nodoc:
      hash.reduce("") { |acc, (key, value)| acc << %Q( #{key}="#{value}") }
    end
    private :hash_to_options
  end
end
