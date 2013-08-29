module Arel

  module UpdateManagerExt

    def set_changes values
      @ast.values_changed = values
    end
  end

  class UpdateManager
    include Arel::UpdateManagerExt
  end
end