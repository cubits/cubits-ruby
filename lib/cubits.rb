require 'logger'

require 'cubits/version'
require 'cubits/connection'
require 'cubits/errors'
require 'cubits/helpers'
require 'cubits/resource'
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
  # @return [Connection] Connection object matching the requested Cubits API key or first
  #                      configured connection
  #
  def self.connection(key = nil)
    @connections ||= {}
    c = key ? @connections[key] : @connections.values.first
    unless c
      fail ConnectionError, "Cubits connection is not configured for key #{key || '(default)'}"
    end
    c
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
