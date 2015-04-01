module Cubits
  class Channel < Resource
    path '/api/v1/channels'
    expose_methods :create, :find, :reload, :update

    has_many :txs, class_name: 'Channel::Tx'

    class Tx < Resource
      belongs_to :channel
    end

    # def txs
    #   @txs ||= ResourceCollection.new(
    #     path: self.class.path_to(id) + '/txs',
    #     resource: Channel::Tx,
    #     expose_methods: [:find, :all]
    #   )
    # end
  end # class Channel
end
