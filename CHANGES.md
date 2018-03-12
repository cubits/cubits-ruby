# 0.7.0

* Added support of concurrent connections. Use `Cubits.active_connection_key()`,
`Cubits.active_connection_key=()` and `Cubits.with_connection_key() { ... }`
to manipulate the connections. 
* The last configured connection is being used by default now.

# 0.6.0

* Added Cubits::ResourceCollection, which implements Ruby [Enumerable](http://ruby-doc.org/core-2.2.1/Enumerable.html)
plus some helper methods
* `Cubits::Channel#txs` now is a `Cubits::ResourceCollection` of `Cubits::Channel::Tx`

# 0.5.0

* Added Cubits::Channel::Tx collection implementation.
Use `channel.txs.all` to retrieve all channel transactions,
`channel.txs.find()` to find a single transaction.

* Added Cubits::Callback module for callback signature verification
and resource instantiation.
Cubits::Invoice, Cubits::Channel, Cubits::Channel::Tx expose .from_callback() method.

# 0.4.0

Enforcing strict server SSL certificate checks, to prevent MitM attacks

# 0.3.1

Changed API base URL to: https://api.cubits.com/

# 0.3.0

Added Cubits::Channel implementation

# 0.2.1

Minor fixes to README.

# 0.2.0

Implemented new API calls:

* Retrieving a list of accounts: `Cubits::Account.all`
* Get a quote for an operation: `Cubits::Quote.create(...)`
* Buy bitcoins using funds in a Cubits account: `Cubits.buy(...)`
* Sell bitcoins and credit funds to a Cubits account: `Cubits.sell(...)`

# 0.1.0

Initial release.

* Configuring connection
* Testing connection: `Cubits.available?`
* Creating, retrieving invoices: `Cubits::Invoice`
* Send bitcoins to a bitcoin address: `Cubits.send_money(...)`
