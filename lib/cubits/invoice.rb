module Cubits
  class Invoice < Resource
    path '/api/v1/invoices'
    expose_methods :create, :find, :reload, :from_callback
  end # class Invoice
end
