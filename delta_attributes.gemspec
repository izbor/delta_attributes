# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'delta_attributes/version'

Gem::Specification.new do |gem|
  gem.name          = "delta_attributes"
  gem.version       = DeltaAttributes::VERSION
  gem.authors       = ["izbor"]
  gem.email         = ["oleh.novosad@gmail.com"]
  gem.description   = %q{
    This gem makes updating specified number fields by ActiveRecord in unusual way.

    Instead to generate sql script to update value in usual way like this:

      UPDATE users
      SET money = 10
      WHERE id = 1;

    It replaces it with

      UPDATE users
      SET money = money + d
      WHERE id = 1;

    where d is difference between old value and new value of that field.

    This solves problem with simultaneous updating of same field.
  }
  gem.summary       = %q{ delta attributes }
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_dependency "rails", "~> 3.2.8"
end
