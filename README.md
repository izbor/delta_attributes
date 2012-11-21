# DeltaAttributes

    This gem makes updating specified number fields by ActiveRecord in unusual way.

    Instead of generating sql script to update value in usual way like this:

      UPDATE users
      SET money = 10
      WHERE id = 1;

    It replaces it with

      UPDATE users
      SET money = money + delta
      WHERE id = 1;

    where delta is difference between old value and new value of that field.

    This solves problem with simultaneous updating of same field by different threads
    without locking record (problem known as race condition http://en.wikipedia.org/wiki/Race_condition).

## Installation

Add this line to your application's Gemfile:

    gem 'delta_attributes'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install delta_attributes

## Usage

  To mark numeric field to be updated by "field = field + delta" way you just need to add field
  name to delta_attributes like this:

    class User < ActiveRecord::Base

      delta_attributes :money

    end

  Now you can:

    u = User.first # money = 3, id = 1
    u.money = 5
    u.save

  rails will generate

    UPDATE users SET money = money + 2 where id = 1

  and if

    u = User.first # money = 5, id = 1
    u.money = 1
    u.money += 3
    u.save

  rails will generate

    UPDATE users SET money = money - 1 where id = 1

  You can use any operations with numeric field like:

  u.money -= 10
  u.money += 7
  u.money = u.money * 2
  etc.

  It doesn't matter as delta is calculated as difference between original value received from database and new value
  before update.

  Tested with rails 3.2.0, 3.2.8, 3.2.9.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
