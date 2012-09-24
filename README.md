# Money for mongoid

Use the [money](https://github.com/RubyMoney/money) gem with Mongoid 2.x and 3.x.

## Install

in Gemfile

```ruby
gem 'money-mongoid'
```

Bundle via Terminal:

`$ bundle`

## Usage

```ruby
require 'money-mongoid'
``

Now also supports MoneyRange with between queries and can even do dynamic currency conversions as part of the query!!! ;)

See specs for usage examples, fx `money/mongoid/3x/money_spec.rb`

## Contributing to money-mongoid
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet.
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it.
* Fork the project.
* Start a feature/bugfix branch.
* Commit and push until you are happy with your contribution.
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

== Copyright

Copyright (c) 2012 Kristian Mandrup. See LICENSE.txt for
further details.

