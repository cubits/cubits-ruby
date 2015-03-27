require 'uri'
require 'json'
require 'http'
require 'openssl'

module Cubits
  class Connection
    CONTENT_TYPE = 'application/vnd.api+json'

    #
    # Creates a new Connection object
    #
    # @param params [Hash]
    # @param params[:key] [String]
    # @param params[:secret] [String]
    #
    def initialize(params)
      fail ArgumentError, 'String is expected as :key' unless params[:key].is_a?(String)
      fail ArgumentError, 'String is expected as :secret' unless params[:secret].is_a?(String)
      @key = params[:key]
      @secret = params[:secret]
      @params = params.dup
    end

    # Executes a GET request
    #
    def get(path, data = {})
      fail ArgumentError, 'Hash is expected as request data' unless data.is_a?(Hash)
      encoded_data = URI.encode_www_form(data)
      request(:get, path, encoded_data)
    end

    # Executes a POST request
    #
    def post(path, data = {})
      fail ArgumentError, 'Hash is expected as request data' unless data.is_a?(Hash)
      encoded_data = data.to_json
      request(:post, path, encoded_data)
    end

    # Signs the message with preconfigured secret
    #
    # @param msg [String]
    #
    # @return [String] Calculated signature
    #
    def sign_message(msg)
      OpenSSL::HMAC.hexdigest('sha512', @secret, msg)
    end

    private

    # Sends a request to the API
    #
    def request(method, path, encoded_data)
      Cubits.logger.warn 'Connecting to Cubits using insecure connection!' if insecure?
      url = URI.join(Cubits.base_url, path)
      params = {}
      http = HTTP.with(cubits_headers(path, encoded_data))
      if method == :get
        url.query = encoded_data unless encoded_data.empty?
      else
        http = http.with('Content-Type' => CONTENT_TYPE)
        params[:body] = encoded_data
      end
      params[:ssl_context] = ssl_context unless insecure?
      Cubits.logger.debug "> #{method.to_s.upcase}: #{url}"
      response = http.send(method, url, params)
      Cubits.logger.debug "< #{response.code} #{response.reason}"
      begin
        body = JSON.parse(response.body)
      rescue JSON::ParserError => e
        raise ConnectionError, "Failed to parse response: #{e}"
      end
      return body if (200...300).include?(response.status)
      respond_with_error(response.code, body['message'])
    end

    # Map unsuccessful HTTP response to appropriate exception and raise it
    #
    def respond_with_error(status, message)
      case status
      when 400
        fail BadRequest, message
      when 403
        fail Forbidden, message
      when 404
        fail NotFound, message
      when 415
        fail UnsupportedMediaType, message
      when 500
        fail InternalServerError, message
      when 400...500
        fail ClientError, message
      when 500...600
        fail ServerError, message
      else
        fail ConnectionError, message
      end
    end

    # Returns timestamp based nonce
    #
    # @return [Integer]
    #
    def self.nonce
      (Time.now.to_f * 1000).to_i
    end

    # Returns complete set of cubits headers
    #
    def cubits_headers(path, encoded_data)
      nonce = self.class.nonce
      signature = sign_request(path, nonce, encoded_data)

      {
        'CUBITS_KEY' => @key,
        'CUBITS_NONCE' => nonce,
        'CUBITS_SIGNATURE' => signature,
        'Accept' => CONTENT_TYPE
      }
    end

    # Calculates request signature
    #
    # @param path [String]
    # @param nonce [Integer,String]
    # @param request_data [String]
    #
    def sign_request(path, nonce, request_data)
      msg = path + nonce.to_s + OpenSSL::Digest::SHA256.hexdigest(request_data)
      signature = sign_message(msg)
      Cubits.logger.debug 'sign_request: ' \
        "path=#{path} nonce=#{nonce} request_data=#{request_data} msg=#{msg} signature=#{signature}"
      signature
    end

    # Returns configured SSLContext
    #
    def ssl_context
      return @ssl_context if @ssl_context
      @ssl_context = OpenSSL::SSL::SSLContext.new
      @ssl_context.verify_mode = OpenSSL::SSL::VERIFY_PEER
      cert_store = OpenSSL::X509::Store.new
      cert_store.set_default_paths
      @ssl_context.cert_store = cert_store
      @ssl_context
    end

    # Returns true if an insecure connection is requested (do NOT use in production)
    #
    def insecure?
      @insecure ||= @params[:insecure] || Cubits.base_url.scheme != 'https'
    end
  end # class Connection
end # module Cubits
