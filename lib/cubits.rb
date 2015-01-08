require 'logger'

require 'cubits/version'
require 'cubits/connection'

module Cubits
  #
  # Configure Cubits connection
  #
  # @param params [Hash]
  # @param params[:key] [String] API key obtained from Cubits
  # @param params[:secret] [String] API secret obtained from Cubits
  #
  def self.configure(params = {})
    @connection = Connection.new(params)
  end

  #
  # Returns configured Connection object
  #
  def self.connection
    @connection || fail(
      "Cubits connection is not configured\n" \
      "  Use:\n" \
      "    Cubits.configure(key: '<YOUR_API_KEY>', secret: '<YOUR_API_SECRET>')"
    )
  end

  # Returns current Logger object
  #
  def self.logger
    @logger ||= Logger.new(nil)
  end

  # Sets new Logger object
  #
  def self.logger=(new_logger)
    @logger = new_logger
  end

  # Resets all internal states
  #
  def self.reset
    @connection = nil
    @logger = nil
  end
end # module Cubits
