[![Build Status](https://secure.travis-ci.org/chiku/spambust.png?branch=master)](https://travis-ci.org/chiku/spambust)

spambust
========

Overview
--------

Prevent spams bots from attacking your website.

Dependencies
------------

These are no runtime dependencies for this gem.

Installation
------------

``` script
gem install spambust
```

Usage
------

**app.rb**

``` ruby
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

  start_app if direct_script_execution?
end
```

**index.erb**

``` erb
<html>
   <head>
      <title>Sample Sinatra application</title>
    </head>
    <body>
      <div id="result"><%= result %></div>

      <form method="post" action="/">
        <label for="user-first-name">First name</label>
        <%= input ["user", "first_name"], :id => "user-first-name" %>

        <label for="user-last-name">Last name</label>
        <%= input ["user", "last_name"], :id => "user-last-name" %>

        <label for="user-email">Email</label>
        <%= input ["user", "email"], :size => 40, :id => "user-email" %>

        <%= submit "Create account", :id => "user-submit" %>
      </form>
   </body>
</html>
```

**output**

``` html
<input type="text" name="ee11cbb19052e40b07aac0ca060c23ee[2a034e9d9e2601c21191cca53760eaaf]" id="user-first-name" />
<input type="hidden" name="user[first_name]" />
```

How does it work?
-----------------

The server will render obfustated input tags for the user to fill. The input tags for the user will be hidden. A spam bot would see the input tags will meaningful names and fill it in. The server will figure out that this response came from a bot and take approriate action.

Running tests
-------------

Clone the repository and run `rake` from the root directory.

Contributing
------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, but do not mess with the VERSION. If you want to have your own version, that is fine but bump the version in a commit by itself in another branch so I can ignore it when I pull.
* Send me a pull request.

License
-------

This gem is released under the MIT license. Please refer to LICENSE for more details.
