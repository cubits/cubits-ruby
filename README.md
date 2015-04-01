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

First thing you have to do is to generate your API token (key+secret) from your [Cubits Pay](https://cubits.com/merchant) account in the API integration section.

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

Invoices are represented by the `Cubits::Invoice` class, which is a descendant of [Hashie::Mash](https://github.com/intridea/hashie#mash), so it's a Hash with a method-like access to its elements:

```ruby
invoice.id # => "686e4238970a92f04f1f5a30035bf024"
invoice.status # => "pending"
invoice.invoice_amount # => "0.00446216"
invoice.invoice_currency # => "BTC"
invoice.address # => "3QJmV3qfvL9SuYo34YihAf3sRCW3qSinyC"
```

#### .create

Creates a new invoice.

For a list of accepted and returned parameters, see the `POST /api/v1/invoices` page in the [Cubits Help Center](https://cubits.com) Developer's section.


```ruby
invoice = Cubits::Invoice.create(price: '1.00', currency: 'EUR')
```

Here a call to `POST /api/v1/invoices` is executed and the response is wrapped in a `Cubits::Invoice` object.


#### .find(*id*)

Retrieves an existing invoice.

```ruby
invoice = Cubits::Invoice.find("686e4238970a92f04f1f5a30035bf024")
```

Returns `Cubits::Invoice` object or `nil` if the specified invoice was not found.


#### #reload

Reloads `Cubits::Invoice` object.
```ruby
invoice = Cubits::Invoice.find("686e4238970a92f04f1f5a30035bf024")
# do some stuff...
invoice.reload # gets the up-to-date invoice data from the Cubits API
```

## Channels

Using the `cubits` Ruby client you can create, update and retrieve channels.

Channels are represented by the `Cubits::Channel` class, which is a descendant of [Hashie::Mash](https://github.com/intridea/hashie#mash), so it's a Hash with a method-like access to its elements:

```ruby
channel.id # => "d17ad6c96f83162a2764ecd4739d7ab2"
channel.receiver_currency # => "EUR"
channel.address # => "3QJmV3qfvL9SuYo34YihAf3sRCW3qSinyC"
```

#### .create

Creates a new channel.

For a list of accepted and returned parameters, see the `POST /api/v1/channels` page in the [Cubits Help Center](https://cubits.com/help) Developer's section.


```ruby
channel = Cubits::Channel.create(receiver_currency: 'EUR')
```

Here a call to `POST /api/v1/channels` is executed and the response is wrapped in a `Cubits::Channel` object.

#### .find(*id*)

Retrieves an existing channel.

```ruby
channel = Cubits::Channel.find("d17ad6c96f83162a2764ecd4739d7ab2")
```

Returns `Cubits::Channel` object or `nil` if the specified channel was not found.

#### #reload

Reloads `Cubits::Channel` object.
```ruby
channel = Cubits::Channel.find("d17ad6c96f83162a2764ecd4739d7ab2")
# do some stuff...
channel.reload # gets the up-to-date channel data from the Cubits API
```

#### #update

Updates attributes of the channel.

For a list of accepted parameters, see the `POST /api/v1/channels/{id}` page in the [Cubits Help Center](https://cubits.com/help) Developer's section.

```ruby
channel = Cubits::Channel.find("d17ad6c96f83162a2764ecd4739d7ab2")
channel.reference # => nil
channel.update(reference: "CHAN_192357")
channel.reference # => "CHAN_192357"
```

#### #txs

Returns channel transactions as a collection of `Cubits::Channel::Tx` objects.

The collection exposes methods `.all` and `.find()`:

Listing all channel transactions:
```ruby
channel = Cubits::Channel.find("d17ad6c96f83162a2764ecd4739d7ab2")

channel.txs.all # => [{"tx_ref_code"=>"YYWZN", ...}, ...]
```

Retrieving a channel transaction with given *tx_ref_code*:
```ruby
channel = Cubits::Channel.find("d17ad6c96f83162a2764ecd4739d7ab2")
tx = channel.txs.find("YYWZN")
tx.class # => Cubits::Channel::Tx

tx # => {"tx_ref_code"=>"YYWZN", "state"=>"pending", ... }
```

### Cubits::Channel::Tx

This resource represents a merchant channel transaction. An instance of `Cubits::Channel::Tx` should be obtained from a `channel.txs` collection or instantiated
from a callback.

#### #channel

Returns the `Cubits::Channel` object, owning this transaction:

```ruby
tx = Cubits::Channel::Tx.from_callback(
  cubits_callback_id: 'ABCDEFGH',
  cubits_key: '7287ba0902...',
  cubits_signature: '7d89c35c2...',
  body: '{"tx_ref_code": "YYWZN", "state": "pending", ...}'
)

tx.channel # => {"receiver_currency"=>"EUR", "name"=>nil, ...}
tx.channel.class # => Cubits::Channel
```

## Accounts

Your Cubits accounts are represented by the `Cubits::Account` class, which is a descendant of [Hashie::Mash](https://github.com/intridea/hashie#mash), so it's a Hash with a method-like access to its elements:
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

Quotes contain information about the current Cubits exchange rate for a certain operation type of a certain amount and can serve as an estimation for subsequent buy or sell requests.

#### .create
Creates a new quote.

For a list of accepted and returned parameters, see the `POST /api/v1/quotes` page in the [Cubits Help Center](https://cubits.com/help) Developer's section.


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

The exact exchange rate will be calculated at the transaction execution time.

#### Parameters
Attribute   | Data type   | Description
------------|-------------|--------------
sender      | Hash        | Sender attributes define the spending part of the transaction
sender[:currency] | String | [ISO 4217](http://en.wikipedia.org/wiki/ISO_4217#Active_codes) code of the currency that you want to spend (e.g. "EUR")
sender[:amount] | String   | Amount in specified currency to be spent, decimal number as a string (e.g. "12.50")

```ruby
Cubits.buy sender: { currency: 'EUR', amount: '150.00' }
# => {"tx_ref_code"=>"RNXH3"}
```

On success, `.buy` creates a transaction and returns its reference code.


## Sell bitcoins

`Cubits.sell` helper method creates a transaction to sell bitcoins from your Cubits wallet and receive the according amount in the specified fiat currency. Fiat funds will be credited to your Cubits cash account.

The exact exchange rate will be calculated at the transaction execution time.

#### Parameters
Attribute   | Data type   | Description
------------|-------------|--------------
sender      | Hash        | Sender attributes define the spending part of the transaction
sender[:amount] | String   | Amount in BTC to be spent, decimal number as a string (e.g. "0.01250000")
receiver    | Hash        | Receiver attributes define the receiving part of the transaction
receiver[:currency] | String | ISO 4217](http://en.wikipedia.org/wiki/ISO_4217#Active_codes) code of the currency that you want to receive (e.g. "EUR")


```ruby
Cubits.sell sender: { amount: '0.45000000' }, receiver: { currency: 'EUR' }
# => {"tx_ref_code"=>"4XRX3"}
```

On success, `.sell` creates a transaction and returns its reference code.


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

## Callbacks

Cubits Merchant API provides an authentication mechanism for callback requests it posts to the merchant specified URL's. That way merchants can be sure, that the data posted within a callback comes from a trusted source.

The callback authentication is described in detail in the [Cubits Help Center](https://cubits.com/help) Developer's section.

The `cubits` ruby gem provides a `Cubits::Callback` class for easy and straightforward callback verification and parsing.

### .from_params()

Provided all relevant headers and body are extracted from the callback request, `from_params()` method validates the signature, parses request body and returns passed data wrapped in a given `Cubits::Resource`-based class object.

Signature of the callback is verified using key+secret pair, passed to `Cubits.configure(...)` beforehand.

#### Parameters
name                 | type    | description
---------------------|---------|---------------------
cubits_callback_id   | String  | Value of the CUBITS_CALLBACK_ID header
cubits_key           | String  | Value of the CUBITS_KEY header
cubits_signature     | String  | Value of the CUBITS_SIGNATURE header
body                 | String  | Callback request body as a String
resource_class       | Resource, nil | (optional) subclass of `Cubits::Resource` (e.g. `Cubits::Invoice`). If specified, an object of that class is instantiated and initialized with the parsed request body. (default: nil)
allow_insecure       | Boolean | (optional) Allow insecure, unsigned callbacks (default: false)

#### Returns

An instance of a given `resource_class` or a `Hash`.

#### Errors

`Cubits::InvalidSignature` is raised if either `cubits_key` passed with the callback
does not match the preconfigured API key, or the `cubits_signature` does not match
the signature calculated from a preconfigured API key+secret pair.

`Cubits::InsecureCallback` is raised if the callback is unsigned, and `allow_insecure` option is *false*.

#### Examples

Validate and parse callback into a plain `Hash`:
```ruby
data = Cubits::Callback.from_params(
  cubits_callback_id: 'ABCDEFGH',
  cubits_key: '7287ba0902...',
  cubits_signature: '7d89c35c2...',
  body: '{"attr1": 123, "attr2": "hello"}'
)

data # => { 'attr1' => 123, 'attr2' => 'hello' }
data.class # => Hash
```

Validate and parse callback into a `Cubits::Invoice` object:
```ruby
invoice = Cubits::Callback.from_params(
  cubits_callback_id: 'ABCDEFGH',
  cubits_key: '7287ba0902...',
  cubits_signature: '7d89c35c2...',
  body: '{"attr1": 123, "attr2": "hello"}',
  resource_class: Cubits::Invoice
)

invoice # => { 'attr1' => 123, 'attr2' => 'hello' }
invoice.class # => Cubits::Invoice
```

Process an insecure, unsigned callback:
```ruby
data = Cubits::Callback.from_params(
  cubits_callback_id: 'ABCDEFGH',
  body: '{"attr1": 123, "attr2": "hello"}',
  allow_insecure: true
)

data # => { 'attr1' => 123, 'attr2' => 'hello' }
```

### Cubits::Resource.from_callback()

`Cubits::Invoice`, `Cubits::Channel` and `Cubits::Channel::Tx` expose
a helper method: `.from_callback()` which can be used to validate callback and instantiate a resource object in one go:

```ruby
invoice = Cubits::Invoice.from_callback(
  cubits_callback_id: 'ABCDEFGH',
  cubits_key: '7287ba0902...',
  cubits_signature: '7d89c35c2...',
  body: '{"attr1": 123, "attr2": "hello"}'
)

invoice # => { 'attr1' => 123, 'attr2' => 'hello' }
invoice.class # => Cubits::Invoice
```

----

