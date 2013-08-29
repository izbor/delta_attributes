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

      alias_method :visit_Arel_Nodes_Assignment_without_deltas, :visit_Arel_Nodes_Assignment
      alias_method :visit_Arel_Nodes_Assignment, :visit_Arel_Nodes_Assignment_with_deltas

      def visit_Arel_Nodes_UpdateStatement o
        if o.orders.empty? && o.limit.nil?
          wheres = o.wheres
        else
          key = o.key
          unless key
            warn(<<-eowarn) if $VERBOSE
(#{caller.first}) Using UpdateManager without setting UpdateManager#key is
deprecated and support will be removed in ARel 4.0.0.  Please set the primary
key on UpdateManager using UpdateManager#key=
            eowarn
            key = o.relation.primary_key
          end

          wheres = [Nodes::In.new(key, [build_subselect(key, o)])]
        end

        [
          "UPDATE #{visit o.relation}",
          ("SET #{o.values_changed.map { |value| visit value }.join ', '}" unless o.values_changed.empty?),
          ("WHERE #{wheres.map { |x| visit x }.join ' AND '}" unless wheres.empty?),
        ].compact.join ' '
      end
    end
  end
end
