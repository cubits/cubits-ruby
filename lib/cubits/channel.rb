module Cubits
  class Channel < Resource
    path '/api/v1/channels'
    expose_methods :create, :find, :reload, :update, :from_callback

    has_many :txs, class_name: 'Channel::Tx'

    class Tx < Resource
      expose_methods :from_callback
      belongs_to :channel
    end
  end # class Channel
end
