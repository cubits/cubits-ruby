module Cubits
  class ConnectionError < StandardError
  end

  # HTTP 4xxx
  class ClientError < ConnectionError
  end

  class BadRequest < ClientError
  end

  class Forbidden < ClientError
  end

  class NotFound < ClientError
  end

  class UnsupportedMediaType < ClientError
  end

  # HTTP 5xx
  class ServerError < ConnectionError
  end

  class InternalServerError < ServerError
  end

  # Cubits client errors
  class InvalidSignature < StandardError
  end

  class InsecureCallback < StandardError
  end
end # module Cubits
