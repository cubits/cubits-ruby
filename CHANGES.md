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
