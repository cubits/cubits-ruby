module Cubits
  class Invoice < Resource
    path '/api/v1/invoices'
    expose_methods :create, :find, :reload
  end # class Invoice
end
