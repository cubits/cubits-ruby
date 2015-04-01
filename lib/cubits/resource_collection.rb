module Cubits
  class ResourceCollection
    attr_reader :path, :resource

    def initialize(params = {})
      @path = params[:path]
      @resource = params[:resource]
      @exposed_methods = params[:expose_methods]
    end

    # By convention collection name for the resource is the last part of the path
    #
    def collection_name
      path.split('/').last
    end

    # @return true if the method is exposed by this resource
    #
    def exposed_method?(method_name)
      (@exposed_methods || []).include?(method_name)
    end


    # Loads collection of resources
    #
    # @return [Array<Resource>]
    #
    def all
      fail NoMethodError, "Resource #{name} does not expose .all" unless exposed_method?(:all)
      Cubits.connection.get(path_to, per_page: 1000)[collection_name].map { |r| resource.new r }
    rescue NotFound
      nil
    end

    # Loads resource
    #
    # @param id [String]
    #
    # @return nil if resource is not found
    #
    def find(id)
      fail NoMethodError, "Resource #{name} does not expose .find" unless exposed_method?(:find)
      resource.new Cubits.connection.get(path_to(id))
    rescue NotFound
      nil
    end

    # Returns API path to resource
    #
    def path_to(resource_or_id = nil)
      fail ArgumentError, "Resource path is not set for #{self}" unless path
      if resource_or_id.is_a?(Resource)
        "#{path}/#{resource_or_id.id}"
      elsif resource_or_id
        "#{path}/#{resource_or_id}"
      else
        path
      end
    end

    def name
      "Collection of #{resource.name}"
    end

    def to_s
      "<#{self.class.name}:<#{resource.name}>:#{path}>"
    end
  end # class ResourceCollection
end # module Cubits
