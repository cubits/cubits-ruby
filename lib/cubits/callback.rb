module Cubits
  class Callback
    #
    # Processes callback request parsed into separate params
    # and instantiates a resource object on success.
    #
    # @param params [Hash]
    # @param params[:cubits_callback_id] [String] Value of the CUBITS_CALLBACK_ID header
    # @param params[:cubits_key] [String] Value of the CUBITS_KEY header
    # @param params[:cubits_signature] [String] Value of the CUBITS_SIGNATURE header
    # @param params[:body] [String] Request body
    # @param params[:resource_class] [Resource,nil] (optional) Instantiate a Resource based object (default: nil)
    #   and initialize it with parsed request body. If not specified, returns parsed body as a plain Hash
    # @param params[:allow_insecure] [Boolean] (optional) Allow insecure, unsigned callbacks (default: false)
    #
    # @return [Resource,Hash]
    #
    # @raise [InvalidSignature]
    # @raise [InsecureCallback]
    #
    def self.from_params(params = {})
      result = from_params_to_hash(params)
      params[:resource_class] ? params[:resource_class].new(result) : result
    end

    private

    def self.from_params_to_hash(params)
      validate_params!(params)
      if params[:cubits_signature] && !params[:cubits_signature].empty?
        validate_signature!(params)
      elsif !params[:allow_insecure]
        fail InsecureCallback, 'Refusing to process an unsigned callback for security reasons'
      end
      JSON.parse(params[:body])
    end

    def self.validate_params!(params)
      unless params[:cubits_callback_id].is_a?(String)
        fail ArgumentError, 'String is expected as :cubits_callback_id'
      end
      if params[:cubits_key] && !params[:cubits_key].is_a?(String)
        fail ArgumentError, 'String is expected as :cubits_key'
      end
      if params[:cubits_signature] && !params[:cubits_signature].is_a?(String)
        fail ArgumentError, 'String is expected as :cubits_signature'
      end
      fail ArgumentError, 'String is expected as :body' unless params[:body].is_a?(String)
      if params[:resource_class]
        unless params[:resource_class].is_a?(Class) && params[:resource_class] < Resource
          fail ArgumentError, 'Resource based class is expected as :resource_class'
        end
      end
      true
    end

    def self.validate_signature!(params)
      connection = Cubits.connection(params[:cubits_key])
      msg = params[:cubits_callback_id] + OpenSSL::Digest::SHA256.hexdigest(params[:body])
      unless connection.sign_message(msg) == params[:cubits_signature]
        fail InvalidSignature, 'Callback signature is invalid'
      end
      true
    rescue ConnectionError => e
      raise InvalidSignature, e.message
    end
  end # class Callback
end
