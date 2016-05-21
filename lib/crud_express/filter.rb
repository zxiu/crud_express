module CrudExpress

  class Filter

    def self.parse(filters)
      filters.each do |filter|
        
      end
    end

    def initialize(collection, name = nil)
      @collection = collection
      @name = name
    end

    def value=(value)
      @value = value
    end

    def &(other)
      self.class.new(self.collection, other)
    end

    def |(other)
    end


  end
end
