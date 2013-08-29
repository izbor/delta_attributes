module Arel
  module Visitors
    module BindVisitor
      private

      def visit_Arel_Nodes_Assignment(o)
        if o.right.is_a? Arel::Nodes::BindParam
          if o.left && o.left.expr && o.left.expr.relation \
            && o.left.expr.relation.engine \
            && o.left.expr.relation.engine.respond_to?(:delta_attributes)  \
            && o.left.expr.relation.engine.delta_attributes.include?(o.left.name)

            l = visit o.left
            "#{l} = #{l} + #{visit o.right}"
          else
            "#{visit o.left} = #{visit o.right}"
          end
        else
          super
        end
      end

    end
  end
end
