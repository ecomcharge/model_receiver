model_receiver
===============

This gem is written to work with rails 3 or sinatra applications using
activerecord.
Add/Update record through ActiveRecord according with received model attributes.

Quick Start For Sinatra Applications
------------------------------------

Add the dependency to your Gemfile

```ruby
gem "model_receiver"
```

Install it...

```ruby
bundle
```

You probably want to password protect the interface, an easy way is to add something like this

```ruby
require 'model_receiver'

module YourSinatra
  class ModelReceiverApp < ModelReceiver::App

    helpers do
      def protected_www
        unless authorized?
          response['WWW-Authenticate'] = %(Basic realm="Enter your user name and password")
          throw(:halt, [401, "Not authorized\n"])
        end
      end

      def authorized?
        @auth ||=  ::Rack::Auth::Basic::Request.new(request.env)
        @auth.provided? && @auth.basic? && @auth.credentials &&
          @auth.credentials == ['login', 'password']
      end
    end

    before { protected_www }

  end
end
```

Add a route to your applications to config.ru file

```ruby
run Rack::URLMap.new({
  "/"               => YourSinatra::App,
  "/model_receiver" => YourSinatra::ModelReceiverApp
})
```

Quick Start For Rails 3 Applications
------------------------------------

Add the dependency to your Gemfile

```ruby
gem "model_receiver"
```

Install it...

```ruby
bundle
```

Add a route to your application for accessing the interface

```ruby
match "/model_receiver" => ModelReceiver::App, :anchor => false
```

You probably want to password protect the interface, an easy way is to add something like this your config.ru file

```ruby
if Rails.env.production?
  ModelReceiver::App.use Rack::Auth::Basic do |username, password|
    username == 'username' && password == 'password'
  end
end
```

Author
------

Mikhail Davidovich