[![Build Status](https://github.com/chiku/spambust/actions/workflows/build.yml/badge.svg)](https://github.com/chiku/spambust/actions/workflows/build.yml)
[![Gem Version](https://badge.fury.io/rb/spambust.svg)](http://badge.fury.io/rb/spambust)
[![Code Climate](https://codeclimate.com/github/chiku/spambust.png)](https://codeclimate.com/github/chiku/spambust)


spambust
========

Overview
--------

Prevent spam bots from attacking your website.

Dependencies
------------

There are no runtime dependencies for this gem.

Installation
------------

```bash
gem install spambust
```

Usage
-----

**app.rb**

```ruby
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

  get "/" do
    erb :index, locals: { result: "..." }
  end

  post '/' do
    result = valid?("user", params) ? "User is #{decrypt("user", params)}" : "Faking is bad"
    erb :index, locals: { result: result }
  end

  start_app if direct_script_execution?
end
```

index.erb

```erb
<html>
<head>
  <title>Sample Sinatra application</title>
</head>
<body>
  <div id="result"><%= result %></div>

  <form method="post" action="/">
    <label for="user-first-name">First name</label>
    <%= input ["user", "first_name"], id: "user-first-name" %>

    <label for="user-last-name">Last name</label>
    <%= input ["user", "last_name"], id: "user-last-name" %>

    <label for="user-email">Email</label>
    <%= input ["user", "email"], size: 40, id: "user-email" %>

    <%= submit "Create account", id: "user-submit" %>
  </form>
</body>
</html>
```

output

```html
<input type="text" name="ee11cbb19052e40b07aac0ca060c23ee[2a034e9d9e2601c21191cca53760eaaf]" id="user-first-name" />
<input type="text" style="position:absolute;top:-10000px;left:-10000px;" name="user[first_name]" />
```

How does it work?
-----------------

The server renders obfuscated input tags for users to fill. The input tags for the user are hidden. A spam bot will see input tags with meaningful names and fill them in. The server detects this and takes appropriate action.

Running tests
-------------

1. Clone the repository.
2. Run `bundle` from the root directory.
3. Run `rake` from the root directory.

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
