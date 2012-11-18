# DeltaAttributes

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

    This solves problem with simultaneous updating of same field by different threads
    without locking record.

## Installation

Add this line to your application's Gemfile:

    gem 'delta_attributes'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install delta_attributes

## Usage

  To mark numeric field to be updated by "field = field + d" way you just need to add field
  name to delta_attributes like this:

    class User < ActiveRecord::Base

      delta_attributes :money

    end

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
