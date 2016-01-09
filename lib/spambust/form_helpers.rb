# form_helpers.rb
#
# Author::    Chirantan Mitra
# Copyright:: Copyright (c) 2013-2016. All rights reserved
# License::   MIT

require 'digest/md5'

module Spambust
  ##
  # <b>Form helpers for sinatra or similar DSLs/frameworks to block for spams</b>
  #
  # @example app.rb
  #    class TestApp < Sinatra::Base
  #      helpers Spambust::FormHelpers
  #
  #      class << self
  #        def start_app
  #          run!
  #        end
  #
  #        def direct_script_execution?
  #          app_file == $PROGRAM_NAME
  #        end
  #      end
  #
  #      get '/' do
  #        erb :index, :locals => { :result => '...' }
  #      end
  #
  #      post '/' do
  #        valid = valid?('user', params)
  #        result =  valid ? "Users is #{decrypt('user', params)}" : 'Faker!'
  #        erb :index, locals: { result: result }
  #      end
  #
  #      start_app if direct_script_execution? && ENV['environment'] != 'test'
  #    end
  #
  # @example index.erb
  #    <html>
  #    <head>
  #      <title>Sample Sinatra application</title>
  #    </head>
  #    <body>
  #      <div id="result"><%= result %></div>
  #      <form method="post" action="/">
  #        <label for="user-first-name">First name</label>
  #        <%= input ["user", "first_name"], :id => "user-first-name" %>
  #        <label for="user-last-name">Last name</label>
  #        <%= input ["user", "last_name"], :id => "user-last-name" %>
  #        <label for="user-email">Email</label>
  #        <%= input ["user", "email"], :size => 40, :id => "user-email" %>
  #        <%= submit "Create account", :id => "user-submit" %>
  #      </form>
  #    </body>
  #    </html>
  module FormHelpers
    HIDING = 'position:absolute;top:-10000px;left:-10000px;' # @api private
    BLOCKED_OPTIONS = [:id, :class, :style] # @api private

    ##
    # Returns obfuscated input tags together with its fake input tags that are
    # rendered off the screen
    #
    # Use inside your templates to generate an obfuscated input field. This is
    # the field that the server will use. If the server sees that fields with
    # original names are filled, the server should assume it be be a spam.
    # It also accepts options for input type and other CSS properties.
    #
    # @example
    #  input(['user', 'name'])
    #  # => <input type="text" name="ee11cbb19052e40b07aac0ca060c23ee[b068931cc450442b63f5b3d276ea4297]" />\
    #  #    <input type="text" name="user[name]" style="position:absolute;top:-10000px;left:-10000px;" />
    #
    # @example
    #  input(['user', 'name'], type: 'password')
    #  # => <input type="password" name="ee11cbb19052e40b07aac0ca060c23ee[b068931cc450442b63f5b3d276ea4297]" />\
    #  #    <input type="text" name="user[name]" style="position:absolute;top:-10000px;left:-10000px;" />
    #
    # @example
    #  input(['user', 'name'], id: 'name', class: 'name')
    #  # => <input id="name" class="name" type="text" \
    #  #    name="ee11cbb19052e40b07aac0ca060c23ee[b068931cc450442b63f5b3d276ea4297]" />\
    #  #    <input type="text" name="user[name]" style="position:absolute;top:-10000px;left:-10000px;" />
    #
    # @param paths [Array<String>]
    # @param options [Hash]
    # @return [String]
    def input(paths, options = {})
      type                = options.delete(:type) || 'text'.freeze
      sanitized_options   = options.reject { |key, _value| BLOCKED_OPTIONS.include?(key) }
      digested_paths      = paths.map { |path| digest(path) }
      visible_tag_options = options.merge(type: type, name: namify(digested_paths))
      hidden_tag_options  = sanitized_options.merge(type: 'text', name: namify(paths), style: HIDING)
      visible_tag = %(<input #{hash_to_options visible_tag_options} />)
      hidden_tag  = %(<input #{hash_to_options hidden_tag_options} />)
      "#{visible_tag}#{hidden_tag}"
    end

    ##
    # Returns submit tags
    #
    # Use inside your templates to generate a submit tag.
    # It also accepts for CSS options.
    #
    # @example
    #  submit('Submit')
    #  # => <input type="submit" value="Submit" />
    #
    # @example
    #  submit('Submit', id: 'submit', class: 'submit')
    #  # => <input id="submit" class="submit" type="submit" value="Submit" />
    #
    # @param text [String]
    # @param options [Hash]
    # @return [String]
    def submit(text, options = {})
      visible_tag_options = options.merge(type: 'submit'.freeze, value: text)
      %(<input #{hash_to_options visible_tag_options} />).gsub('  ', ' ')
    end

    ##
    # Returns a nested input name
    #
    # @api private
    # @param paths [Array<String>]
    # @return [String]
    def namify(paths)
      first = paths[0]
      rest  = paths[1..-1].reduce('') { |a, e| a << "[#{e}]" }
      "#{first}#{rest}"
    end

    ##
    # Returns decrypted hash of user submitted POST parameters
    # Use inside your application.
    #
    # @example
    #  decrypt('user', params)
    #
    # @param lookup [String]
    # @param global [Hash]
    def decrypt(lookup, global)
      fake = global[lookup] || {}
      hashed_lookup = digest(lookup)
      subset = global[hashed_lookup] || {}

      fake.each_with_object({}) do |(key, _value), real|
        real[key] = subset[digest(key)]
      end
    end

    ##
    # Returns if any POST data was present in the fake input fields
    #
    # Use inside your application.
    #
    # @example
    #  valid?('user', params)
    #
    # @param lookup [String]
    # @param global [Hash]
    def valid?(lookup, global)
      fake = global[lookup] || {}
      fake.values.all?(&:empty?)
    end

    def hash_to_options(hash)
      hash.map { |key, value| %(#{key}="#{value}") }.join(' ')
    end
    private :hash_to_options

    def digest(item)
      Digest::MD5.hexdigest(item)
    end
    private :digest
  end
end
