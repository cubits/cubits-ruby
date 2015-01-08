module Cubits
  class Connection
    #
    # Creates a new Connection object
    #
    # @param params [Hash]
    # @param params[:key] [String]
    # @param params[:secret] [String]
    #
    def initialize(params)
      @key = params[:key] || fail(ArgumentError, ':key is not specified')
      @secret = params[:secret] || fail(ArgumentError, ':secret is not specified')
    end

    # Executes a GET request
    #
    def get(_request_name, _data = {})
    end

    # Executes a POST request
    #
    def post(_request_name, _data = {})
    end
  end # class Connection
end # module Cubits
