module Cubits
  class Quote < Resource
    path '/api/v1/quotes'

    expose_methods :create
  end # class Quote
end
