require 'hashie'

module Cubits
  class Resource < Hashie::Mash
    #
    # Sets path for the resource
    #
    def self.path(p)
      @path = p
    end

    # Returns API path to resource
    #
    def self.path_to(resource_or_id = nil)
      fail ArgumentError, "Resource path is not set for #{self.class.name}" unless @path
      if resource_or_id.is_a?(Resource)
        "#{@path}/#{resource_or_id.id}"
      elsif resource_or_id
        "#{@path}/#{resource_or_id}"
      else
        @path
      end
    end

    # Loads resource
    #
    # @param id [String]
    #
    # @return nil if resource is not found
    #
    def self.find(id)
      self.new Cubits.connection.get(path_to(id))
    rescue NotFound
      nil
    end

    # Reloads resource
    #
    def reload
      fail "Resource #{self.class.name} does not have an id" unless self.respond_to?(:id)
      replace(self.class.find(id))
    end

    # Creates a new resource
    #
    def self.create(params = {})
      self.new Cubits.connection.post(path_to, params)
    end
  end # class Resource
end # module Cubits
