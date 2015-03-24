module Cubits
  class Channel < Resource
    path '/api/v1/channels'
    expose_methods :create, :find, :reload, :update
  end # class Channel
end
