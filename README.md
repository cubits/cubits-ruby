# Cubits API client

A Ruby client for [Cubits](https://cubits.com) Merchant API v1.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cubits'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cubits

## Usage

First thing you have to do is to get your API token (key+secret) from Cubits **(...Merchant integration tab?)**

Then, configure your Cubits client:
```ruby
require 'cubits'

Cubits.configure(key: '***', secret: '***')
```

Now you can test your API connection:
```ruby
require 'cubits'

Cubits.configure(key: '***', secret: '***')

Cubits.available? # => true
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/cubits/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
