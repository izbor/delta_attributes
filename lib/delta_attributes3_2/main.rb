require 'set'
require 'delta_attributes3_2/update_statement'
require 'delta_attributes3_2/update_manager'
require 'delta_attributes3_2/to_sql'
require 'delta_attributes3_2/mysql'
require 'delta_attributes3_2/crud'
require 'delta_attributes3_2/visitor'

module ActiveRecord
  # = Active Record Persistence
  module Persistence

    def update(attribute_names = @attributes.keys)
      return super(attribute_names) if self.new_record?

      attributes_with_values = arel_attributes_values(false, false, attribute_names)
      return 0 if attributes_with_values.empty?

      attributes = { }
      @changed_attributes.each do |attribute_name, value|
        if self.class.delta_attributes.include?(attribute_name.intern) && !self.excluded_deltas.include?(attribute_name.intern)
          attributes[attribute_name] = value
        end
      end

      klass = self.class
      stmt = klass.unscoped.where(klass.arel_table[klass.primary_key].eq(id)).arel.compile_full_update(attributes_with_values, attributes)
      klass.connection.update stmt
    end

    def excluded_deltas
      @_excluded_deltas ||= Set.new
    end

    def force_clobber(attr_name, value)
      self.excluded_deltas.add(attr_name.to_s.intern)
      send("#{attr_name}=", value)
    end

    class InvalidDeltaColumn < StandardError;
    end

    def self.included(base) #:nodoc:
      base.extend ClassMethods
    end

    module ClassMethods

      def delta_attributes(*args)
        @_delta_attributes ||= Set.new

        return @_delta_attributes if args.empty?

        args.each do |attribute|
          if self.columns_hash[attribute.to_s] && !self.columns_hash[attribute.to_s].number?
            raise InvalidDeltaColumn.new("Delta attributes only work with number attributes, column `#{attribute}` is not a number.")
          end
          @_delta_attributes.add(attribute)
        end
      end
    end
  end

end