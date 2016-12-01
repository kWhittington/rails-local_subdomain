# Rails::LocalSubdomain
Rails localhost subdomain support.

## Description

`Rails::LocalSubdomain` enables the developer access to routes within a
`Rails` subdomain (e.g. testing, Q.A.). It should work out of the box.

Almost all of the work was completed by https://github.com/manuelvanrijn
(https://github.com/manuelvanrijn/local-subdomain). I only
wanted to add the ability to configure which environments will have `Rails`
subdomain support. Specifically, I was trying to test a Rails application via
`Capybara` and had to modify the original gem source to let us access
subdomains during tests.

## Installation

1. Add the gem to your `Gemfile`, preferably outside of any group.

```ruby
gem 'rails-local_subdomain', group: :test # bad

gem 'rails-local_subdomain' # good
```

2. Run `bundle install`
3. Include the `Rails::LocalSubdomain` module into a controller
   (usually `ApplicationController`)

```ruby
require 'rails/local_subdomain'

class ApplicationController < ActionController::Base
  include Rails::LocalSubdomain
  ....
end
```

Subdomains should now be accessible in all `Rails` environments white listed in
`Rails::LocalSubdomain.enabled_environments`.

## Configuration

Configuration can be easily done via `Rails` initializers, simply monkey-patch
in whatever values you wish to customize:

```ruby
# ./config/initializers/rails/local_subdomain.rb

module Rails
  module LocalSubdomain
    def self.enabled_environments
      %w(develop test)
    end
  end
end
```

## How does it work?

### Rack::Handler

`Rails::LocalSubdomain` monkey-patches `Rack::Handler` to bind to `0.0.0.0`
rather than `localhost`.

By default, this gem uses the domain [http://lvh.me](http://lvh.me) to handle
our requests for our subdomain(s). Request to the domain `lvh.me` redirects all
requests to `127.0.0.1`.

This give's us the ability to browse to
[http://subdomain.lvh.me:3000](http://subdomain.lvh.me:3000) and handle
`request.subdomain` from our controllers.

Because we're going to use the external domain [http://lvh.me](http://lvh.me)
which redirects to `127.0.0.1` we have to make our server not to bind to
`localhost` only.

### LocalSubdomain module

This module includes a `before_action` which will check if the request is
served by [http://lvh.me](http://lvh.me). If not it will redirect to the domain.

So when we browse to [http://localhost:3000](http://localhost:3000) it will
redirect you to [http://lvh.me:3000](http://lvh.me:3000)

## Supported ruby servers

I've tested the gem with:

* [WEBrick](https://rubygems.org/gems/webrick)
* [Puma](http://puma.io/)
* [Thin](http://code.macournoyer.com/thin/)

## Credits

Thanks to https://github.com/manuelvanrijn/local-subdomain for coming up with
the original gem. It's helped my development a lot!
