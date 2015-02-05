module Cubits
  module Helpers
    #
    # Runs a few calls to Cubits API and returns true if the connection
    # to the API is configured correctly.
    #
    def available?
      Cubits.connection.get('/api/v1/test', foo: 'bar')
      Cubits.connection.post('/api/v1/test', foo: 'bar')
      true
    rescue StandardError
      false
    end

    #
    # Executes "Send money" API call.
    # Sends Bitcoins from Cubits Wallet to external Bitcoin address.
    #
    # @param params [Hash]
    # @param params[:amount] [String] Amount to be sent, decimal as a String (e.g. "0.12340000")
    # @param params[:address] [String] Bitcoin address the amount is to be sent to
    #
    def send_money(params)
      fail ArgumentError, 'Hash is expected as params' unless params.is_a?(Hash)
      fail ArgumentError, 'String is expected as :amount' unless params[:amount].is_a?(String)
      fail ArgumentError, 'String is expected as :address' unless params[:address].is_a?(String)
      fail ArgumentError, 'Invalid amount format' unless params[:amount] =~ /^\d+\.\d+$/
      fail ArgumentError, 'Invalid address format' unless params[:address] =~ /^[A-Za-z0-9]+$/
      Cubits.connection.post(
        '/api/v1/send_money',
        amount: params[:amount], address: params[:address]
      )
    end

    # Executes "Buy bitcoins" API call.
    # Buy Bitcoins using funds in a Cubits account. Bought Bitcoins will be credited
    # to your Cubits Wallet.
    #
    # @param params [Hash]
    # @param params[:sender] [Hash] Sender attributes define spending part of transaction
    # @param params[:sender][:currency] [String] ISO 4217 code of the currency, that you want
    #                                            to spend (e.g. "EUR")
    # @param params[:sender][:amount] [String] Amount in specified currency to be spent,
    #                                          decimal number as a String (e.g. "12.50")
    #
    def buy(params)
      fail ArgumentError, 'Hash is expected as params' unless params.is_a?(Hash)
      fail ArgumentError, 'Hash is expected as :sender' unless params[:sender].is_a?(Hash)
      sender = params[:sender]
      fail ArgumentError, 'String is expected as sender[:currency]' unless sender[:currency].is_a?(String)
      fail ArgumentError, 'String is expected as sender[:amount]' unless sender[:amount].is_a?(String)
      fail ArgumentError, 'Invalid amount format' unless sender[:amount] =~ /^\d+\.\d+$/
      Cubits.connection.post(
        '/api/v1/buy',
        sender: {
          currency: sender[:currency],
          amount: sender[:amount]
        }
      )
    end


    # Executes "Sell bitcoins" API call.
    #
    # Creates a transaction to sell bitcoins from your Cubits wallet and receive amount
    # in specified fiat currency. Fiat funds will be credited to your Cubits account.
    #
    # @param params [Hash]
    # @param params[:sender] [Hash] Sender attributes define spending part of transaction
    # @param params[:sender][:amount] [String] Amount in bitcoins to be spent,
    #                                          decimal number as a String (e.g. "0.01250000")
    # @param params[:receiver] [Hash] Receiver attributes define receiving part of transaction
    # @param params[:receiver][:currency] [String] ISO 4217 code of the currency, that you want
    #                                            to receive (e.g. "EUR")
    #
    def sell(params)
      fail ArgumentError, 'Hash is expected as params' unless params.is_a?(Hash)
      fail ArgumentError, 'Hash is expected as :sender' unless params[:sender].is_a?(Hash)
      sender = params[:sender]
      fail ArgumentError, 'String is expected as sender[:amount]' unless sender[:amount].is_a?(String)
      fail ArgumentError, 'Invalid amount format' unless sender[:amount] =~ /^\d+\.\d+$/
      fail ArgumentError, 'Hash is expected as :receiver' unless params[:receiver].is_a?(Hash)
      receiver = params[:receiver]
      fail ArgumentError, 'String is expected as receiver[:currency]' unless receiver[:currency].is_a?(String)
      Cubits.connection.post(
        '/api/v1/sell',
        sender: {
          amount: sender[:amount]
        },
        receiver: {
          currency: receiver[:currency]
        }
      )
    end
  end # module Helpers
end # module Cubits
