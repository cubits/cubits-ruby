# Cubits API client

A Ruby 1.9+ client for [Cubits](https://cubits.com) Merchant API v1.

# Installation

Add this line to your application's Gemfile:

```ruby
gem 'cubits'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cubits

# Usage

## Configuration

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

## Invoices

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

## Accounts

Your Cubits accounts are represented by `Cubits::Account` class, which is descendant of  of [Hashie::Mash](https://github.com/intridea/hashie#mash),
so it's a Hash with a method-like access to its elements:
```ruby
account = Cubits::Account.all.first

account.currency # => "EUR"
account.balance # => "125.00"
```

#### .all

Retrieves a list of accounts.

Returns `Array` of `Cubits::Account` objects.

```ruby
Cubits::Account.all # => [{ currency: 'EUR', balance: '125.00' }, ...]
```

## Quotes

Requests a quote for a *"buy"* or *"sell"* operation.

Quotes provide estimation of the exchange rate for a given amount and operation type.

#### .create
Creates a new quote.

For a list of accepted and returned parameters, see `POST /api/v1/quotes` page in the [Cubits Help Center](https://cubits.com/help) Developer's section.


```ruby
quote = Cubits::Quote.create(
  operation: 'buy',
  sender: {
    currency: 'EUR'
  },
  receiver: {
    currency: 'BTC',
    amount: '1.0'
  }
)

quote.sender # => {"currency"=>"EUR", "amount"=>"172.81"}
```

Here a call to `POST /api/v1/quotes` is executed and the response is wrapped in a `Cubits::Quote` object.


## Buy bitcoins

`Cubits.buy` helper method creates a transaction to buy bitcoins using funds from your Cubits account. Bought bitcoins will be credited to your Cubits wallet.

Exact exchange rate will be calculated at the transaction execution time.

#### Parameters
Attribute   | Data type   | Description
------------|-------------|--------------
sender      | Hash        | Sender attributes define spending part of transaction
sender[:currency] | String | [ISO 4217](http://en.wikipedia.org/wiki/ISO_4217#Active_codes) code of the currency that you want to spend (e.g. "EUR")
sender[:amount] | String   | Amount in specified currency to be spent, decimal number as a string (e.g. "12.50")

```ruby
Cubits.buy sender: { currency: 'EUR', amount: '150.00' }
# => {"tx_ref_code"=>"RNXH3"}
```

On success `.buy` creates a transaction and returns its reference code.


## Sell bitcoins

`Cubits.sell` helper method creates a transaction to sell bitcoins from your Cubits wallet and receive amount in specified fiat currency. Fiat funds will be credited to your Cubits account.

Exact exchange rate will be calculated at the transaction execution time.

#### Parameters
Attribute   | Data type   | Description
------------|-------------|--------------
sender      | Hash        | Sender attributes define spending part of transaction
sender[:amount] | String   | Amount in BTC to be spent, decimal number as a string (e.g. "0.01250000")
receiver    | Hash        | Receiver attributes define receiving part of transaction
receiver[:currency] | String | ISO 4217](http://en.wikipedia.org/wiki/ISO_4217#Active_codes) code of the currency that you want to receive (e.g. "EUR")


```ruby
Cubits.sell sender: { amount: '0.45000000' }, receiver: { currency: 'EUR' }
# => {"tx_ref_code"=>"4XRX3"}
```

On success `.sell` creates a transaction and returns its reference code.

## Sell bitcoins

Sell bla bla bla

## Send money

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



