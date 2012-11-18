module Arel
  module Visitors
    class ToSql < Arel::Visitors::Visitor

      def visit_Arel_Nodes_Assignment_with_deltas o
        return visit_Arel_Nodes_Assignment_without_deltas o unless o.is_a?(Arel::Nodes::DeltaAttribute)
        return visit_Arel_Nodes_Assignment_without_deltas o.arel_node unless o.valid?

        old_value = o.old_value
        new_value = o.new_value

        delta_string = "#{visit o.arel_node.left} "
        delta_string << (old_value > new_value ? "-" : "+")
        delta_string << " #{(old_value - new_value).abs}"

        "#{visit o.arel_node.left} = #{delta_string}"
      end

      #alias_method_chain :visit_Arel_Nodes_Assignment, :deltas

      alias_method :visit_Arel_Nodes_Assignment_without_deltas, :visit_Arel_Nodes_Assignment
      alias_method :visit_Arel_Nodes_Assignment, :visit_Arel_Nodes_Assignment_with_deltas
    end
  end
end
