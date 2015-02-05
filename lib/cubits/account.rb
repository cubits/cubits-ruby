module Cubits
  class Account < Resource
    path '/api/v1/accounts'
    expose_methods :all
  end # class Account
end
