
class DeltaAttributesRailtie < Rails::Railtie

  initializer 'delta_attributes.configure_rails_initialization', {:after => 1} do
     load 'delta_attributes4/main.rb'
  end

end