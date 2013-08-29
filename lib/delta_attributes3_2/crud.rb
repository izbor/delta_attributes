module Arel
  module Crud

    def compile_full_update values, changed_values
      um = compile_update values
      um.set_changes changed_values unless changed_values.empty?
      um
    end

  end
end