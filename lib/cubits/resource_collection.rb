module Cubits
  class ResourceCollection
    include Enumerable

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

    # Returns number of elements in the collection
    #
    def count
      pagination.total_count
    end
    alias_method :size, :count

    # Loads collection of resources
    #
    # @return [Array<Resource>]
    #
    def all
      fail NoMethodError, "Resource #{name} does not expose .all" unless exposed_method?(:all)
      list = []
      page_count.times do |i|
        list += page(i + 1)
      end
      list
    rescue NotFound
      []
    end

    # Returns first element of the collection
    #
    def first
      first_page.first
    end

    # Returns last element of the collection
    #
    def last
      last_page.last
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

    # Reloads collection
    #
    # @return [self]
    #
    def reload
      @pagination = nil
      @pages = nil
      self
    end

    # Iterates through the collection, yielding the giving block for each resource.
    #
    def each(&_block)
      return to_enum unless block_given?
      page_count.times do |i|
        page(i + 1).each do |r|
          yield r
        end
      end
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
      "<#{self.class.name} of #{resource.name}, #{path}>"
    end

    private

    # Returns current pagination object.
    # If pagination was not requested yet, does a one page request
    #
    def pagination
      return @pagination if @pagination
      first_page
      @pagination
    end

    # Returns number of pages
    #
    def page_count
      pagination.page_count
    end

    # Returns collection of pages as a Hash:
    # {
    #   <page_number> => [<resource>, ...],
    #   <page_number> => [<resource>, ...],
    #   ...
    # }
    #
    def pages
      @pages ||= {}
    end

    # Returns i-th page
    #
    def page(i)
      pages[i] ||= load_page(i)
    end

    # Loads i-th page
    #
    def load_page(i)
      response = Cubits.connection.get(path_to, page: i)
      @pagination = Hashie::Mash.new(response['pagination'])
      response[collection_name].map { |r| resource.new r }
    end

    # Returns first page of the collection
    #
    def first_page
      page(1)
    end

    # Returns last page of the collection
    #
    def last_page
      page(page_count)
    end
  end # class ResourceCollection
end # module Cubits
