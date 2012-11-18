module Arel
  module Visitors
    class Visitor

      def visit_with_delta_attribute obj
        return visit_without_delta_attribute obj unless obj.is_a?(Arel::Nodes::DeltaAttribute)
        return visit_without_delta_attribute obj.arel_node unless obj.valid?

        object = obj.arel_node
        send dispatch[object.class], obj
      rescue NoMethodError => e
        raise e if respond_to?(dispatch[object.class], true)
        superklass = object.class.ancestors.find { |klass|
          respond_to?(dispatch[klass], true)
        }
        raise(TypeError, "Cannot visit #{object.class}") unless superklass
        dispatch[object.class] = dispatch[superklass]
        retry
      end

      #alias_method_chain :visit, :delta_attribute

      alias_method :visit_without_delta_attribute, :visit
      alias_method :visit, :visit_with_delta_attribute
    end
  end
end
