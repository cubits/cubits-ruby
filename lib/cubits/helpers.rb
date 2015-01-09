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
  end # module Helpers
end # module Cubits
