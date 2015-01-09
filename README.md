# Cubits API client

A Ruby 1.9+ client for [Cubits](https://cubits.com) Merchant API v1.

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

### Configuration

First thing you have to do is to get your API token (key+secret) from Cubits  *...Merchant integration tab?..*

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

### Invoices

Using the `cubits` Ruby client you can create and retrieve invoices.

Invoices are represented by `Cubits::Invoice` class, which is a descendant of [Hashie::Mash](https://github.com/intridea/hashie#mash),
so it's a Hash with a method-like access to its elements:

```ruby
invoice.id # => "686e4238970a92f04f1f5a30035bf024"
invoice.status # => "pending"
invoice.invoice_amount # => "0.00446216"
invoice.invoice_currency # => "BTC"
invoice.address # => "2MwFC54RmUyHtyNcNuxtU5zW4hCGTvYuXti"
```

#### .create

Creates a new invoice.

For a list of accepted and returned parameters, see `POST /api/v1/invoices` page in the [Cubits Help Center](https://cubits.com/help) Developer's section.


```ruby
invoice = Cubits::Invoice.create(price: '1.00', currency: 'EUR')
```

Here a call to `POST /api/v1/invoices` is executed and the response is wrapped in a `Cubits::Invoice` object.


#### .find(*id*)

Retrieves an existing invoice.

```ruby
invoice = Cubits::Invoice.find("686e4238970a92f04f1f5a30035bf024")
```

Returns `Cubits::Invoice` object or `nil` if invoice was not found.


#### #reload

Reloads `Cubits::Invoice` object.
```ruby
invoice = Cubits::Invoice.find("686e4238970a92f04f1f5a30035bf024")
# do some stuff...
invoice.reload # gets the up-to-date invoice data from Cubits API
```

### Send money

`Cubits.send_money` helper method allows you to send Bitcoin from your Cubits Wallet to an external Bitcoin address.

#### Parameters
name     | type    | description
---------|---------|---------------------
amount   | String  | Amount in BTC to be sent, decimal as a String (e.g. "0.1234000")
address  | String  | Bitcoin address to send the amount to

```ruby
Cubits.send_money amount: '1.5000000', address: '3BnYBqPnGtRz2cfcnhxFKy3JswU3biMk5q'
# => {"tx_ref_code"=>"64RHH"}
```

On success `.send_money` creates a transaction and returns its reference code.

----



