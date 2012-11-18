module Arel
  module Nodes

    class DeltaAttribute

      attr_accessor :arel_node, :new_value, :old_value

      def initialize(arel_node, new_value = nil, old_value = nil)
        @arel_node = arel_node
        @new_value = new_value
        @old_value = old_value
      end

      def valid?
        @arel_node && !new_value.nil? && !old_value.nil?
      end

    end

    module UpdateStatementExt

      def values_changed=(values)
        instance_variable_set("@values_changed", values)
      end

      def values_changed
        changed = instance_variable_get("@values_changed")
        return @values unless changed

        @values.map {|m|
          attr_name = m.left.expr.name
          new_value = m.right
          if changed[attr_name]
            Arel::Nodes::DeltaAttribute.new(m, new_value, changed[attr_name])
          else
            m
          end
        }
      end

    end

    class UpdateStatement
      include Arel::Nodes::UpdateStatementExt
    end

  end


end