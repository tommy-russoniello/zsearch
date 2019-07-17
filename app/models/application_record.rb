class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  class << self
    def sort_attributes
      @sort_attributes ||= (attribute_names + has_many_attributes).sort
    end

    def boolean_attributes
      @boolean_attributes ||= attribute_types.each_with_object([]) do |data, array|
        array << data.first if data.last.type == :boolean
      end
    end

    def enum_attributes
      @enum_attributes ||= attribute_types.each_with_object([]) do |data, array|
        array << data.first if data.last.is_a?(ActiveRecord::Enum::EnumType)
      end
    end

    def has_many_attributes
      []
    end
  end
end
