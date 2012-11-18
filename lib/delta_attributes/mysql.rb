module Arel
  module Visitors
    class MySQL < Arel::Visitors::ToSql

      private

      def visit_Arel_Nodes_UpdateStatement o
        [
            "UPDATE #{visit o.relation}",
            ("SET #{o.values_changed.map { |value| visit value }.join ', '}" unless o.values.empty?),
            ("WHERE #{o.wheres.map { |x| visit x }.join ' AND '}" unless o.wheres.empty?),
            ("ORDER BY #{o.orders.map { |x| visit x }.join(', ')}" unless o.orders.empty?),
            (visit(o.limit) if o.limit),
        ].compact.join ' '
      end

      # original
      #def visit_Arel_Nodes_UpdateStatement o
      #  [
      #    "UPDATE #{visit o.relation}",
      #    ("SET #{o.values.map { |value| visit value }.join ', '}" unless o.values.empty?),
      #    ("WHERE #{o.wheres.map { |x| visit x }.join ' AND '}" unless o.wheres.empty?),
      #    ("ORDER BY #{o.orders.map { |x| visit x }.join(', ')}" unless o.orders.empty?),
      #    (visit(o.limit) if o.limit),
      #  ].compact.join ' '
      #end
    end
  end
end

