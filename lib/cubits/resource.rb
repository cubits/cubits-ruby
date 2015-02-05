require 'hashie'

module Cubits
  class Resource < Hashie::Mash
    #
    # Sets path for the resource
    #
    def self.path(p)
      @path = p
    end

    # By convention collection name for the resource is the last part of the path
    #
    def self.collection_name
      @path.split('/').last
    end

    # Sets exposed methods for the resource
    #
    def self.expose_methods(*args)
      @exposed_methods = args
    end

    # @return true if the method is exposed by this resource
    #
    def self.exposed_method?(method_name)
      (@exposed_methods || []).include?(method_name)
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

    # Loads collection of resources
    #
    # @return [Array<Resource>]
    #
    def self.all
      fail NoMethodError, "Resource #{name} does not expose .all" unless exposed_method?(:all)
      Cubits.connection.get(path_to)[collection_name].map { |r| new r }
    rescue NotFound
      nil
    end

    # Loads resource
    #
    # @param id [String]
    #
    # @return nil if resource is not found
    #
    def self.find(id)
      fail NoMethodError, "Resource #{name} does not expose .find" unless exposed_method?(:find)
      new Cubits.connection.get(path_to(id))
    rescue NotFound
      nil
    end

    # Reloads resource
    #
    def reload
      unless self.class.exposed_method?(:reload)
        fail NoMethodError, "Resource #{self.class.name} does not expose #reload"
      end
      fail "Resource #{self.class.name} does not have an id" unless self.respond_to?(:id)
      replace(self.class.find(id))
    end

    # Creates a new resource
    #
    def self.create(params = {})
      fail NoMethodError, "Resource #{name} does not expose .create" unless exposed_method?(:create)
      new Cubits.connection.post(path_to, params)
    end
  end # class Resource
end # module Cubits
