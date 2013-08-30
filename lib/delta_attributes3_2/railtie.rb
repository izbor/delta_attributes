class DeltaAttributesRailtie < Rails::Railtie

  initializer 'delta_attributes.configure_rails_initialization' do
    ActiveSupport.on_load(:active_record) do
      require 'delta_attributes3_2/main.rb'
    end
  end

end