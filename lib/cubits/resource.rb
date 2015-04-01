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

    # Associations
    def self.has_many(association_name, params = {})
      define_method(association_name) do
        association = instance_variable_get("@#{association_name}")
        return association if association
        class_name = params[:class_name] || association_name.to_s.capitalize.sub(/s$/, '')
        resource = Cubits.const_get(class_name) || fail("Failed to find class #{class_name}")
        association = ResourceCollection.new(
          path: self.class.path_to(id) + '/' + association_name.to_s,
          resource: resource,
          expose_methods: params[:expose_methods] || [:find, :all]
        )
        instance_variable_set("@#{association_name}", association)
        association
      end
    end

    def self.belongs_to(association_name, params = {})
      define_method(association_name) do
        association_id = send :"#{association_name}_id"
        unless association_id
          fail ArgumentError, "No #{association_name}_id attribute is defined for #{self}"
        end
        class_name = params[:class_name] || association_name.to_s.capitalize
        resource = Cubits.const_get(class_name) || fail("Failed to find class #{class_name}")
        resource.find(association_id)
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

    # Updates the resource
    #
    def update(params = {})
      unless self.class.exposed_method?(:update)
        fail NoMethodError, "Resource #{self.class.name} does not expose #update"
      end
      fail "Resource #{self.class.name} does not have an id" unless self.respond_to?(:id)
      replace(self.class.new Cubits.connection.post(self.class.path_to(id), params))
    end

    # Creates a new resource
    #
    def self.create(params = {})
      fail NoMethodError, "Resource #{name} does not expose .create" unless exposed_method?(:create)
      new Cubits.connection.post(path_to, params)
    end
  end # class Resource
end # module Cubits
