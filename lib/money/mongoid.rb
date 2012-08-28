require 'money'
require 'money/mongoid/core_ext'
require 'money/orm/generic'

if Mongoid::VERSION > '3'
  require "money/mongoid/3x/money"
else
  require "money/mongoid/2x/money"
end

module Mongoid
  module Money
    class << self
      attr_accessor :default_polymorphic_money
    end
  end
end
