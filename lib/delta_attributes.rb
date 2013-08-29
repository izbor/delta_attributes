require 'shared/version'

if defined?(Rails)

  load 'delta_attributes3_2/railtie.rb' if Rails::VERSION::MAJOR == 3

  load 'delta_attributes4/railtie.rb' if Rails::VERSION::MAJOR == 4

end
