require 'logger'

require 'cubits/version'
require 'cubits/connection'
require 'cubits/errors'
require 'cubits/helpers'
require 'cubits/resource'
require 'cubits/resource_collection'
require 'cubits/invoice'
require 'cubits/account'
require 'cubits/quote'
require 'cubits/channel'
require 'cubits/callback'

module Cubits
  extend Cubits::Helpers

  DEFAULT_BASE_URL = URI.parse('https://api.cubits.com/')

  #
  # Configure Cubits connection
  #
  # @param params [Hash]
  # @param params[:key] [String] API key obtained from Cubits
  # @param params[:secret] [String] API secret obtained from Cubits
  #
  def self.configure(params = {})
    @connections ||= {}
    @connections[params[:key]] = Connection.new(params)
  end

  # Returns configured Connection object
  #
  # @param key [String] (optional) Cubits API key of the configured connection
  #
  # @return [Connection] Connection object matching the requested Cubits API key
  #                      or Connection object matching Cubits.active_connection_key
  #
  def self.connection(key = active_connection_key)
    if @connections.nil? || @connections[key].nil?
      fail ConnectionError, "Cubits connection is not configured for key #{key || '(default)'}"
    end
    @connections[key]
  end

  # Returns current Cubits connection key (Cubits API key)
  #
  # @return [String] current thread-local active connection key
  #                  or the last configured connection key
  #
  def self.active_connection_key
    Thread.current[:cubits_active_connection_key] || @connections&.keys&.last
  end

  # Sets current Cubits connection to given Cubits API key
  #
  # @param key [String] Cubits API key of the configured connection
  #
  def self.active_connection_key=(key)
    if @connections.nil? || @connections[key].nil?
      fail ConnectionError, "Cubits connection is not configured for key #{key}"
    end
    Thread.current[:cubits_active_connection_key] = key
  end

  # Sets current Cubits connection to given Cubits API key and yields given block
  #
  # @param key [String] Cubits API key of the configured connection
  #
  def self.with_connection_key(key)
    connection_key_was = active_connection_key
    self.active_connection_key = key
    yield if block_given?
  ensure
    self.active_connection_key = connection_key_was
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

  # Returns current base API URL
  #
  def self.base_url
    @base_url ||= DEFAULT_BASE_URL
  end

  # Sets new base API URL
  #
  # @param new_base_url [URI,String]
  #
  def self.base_url=(new_base_url)
    new_base_url = URI.parse(new_base_url) if new_base_url.is_a?(String)
    fail ArgumentError, 'URI is expected as new_base_url' unless new_base_url.is_a?(URI)
    @base_url = new_base_url
  end

  # Resets all internal states
  #
  def self.reset
    @connections = {}
    @logger = nil
  end
end # module Cubits
