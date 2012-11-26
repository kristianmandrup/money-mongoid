require 'money'
require 'sugar-high/delegate'
require 'money/mongoid/core_ext'

require 'money/orm/generic'
require 'money/mongoid/macros'
require 'money/mongoid/monetizable'
require 'money/mongoid/monetize'

require 'money/orm/generic'

if ::Mongoid::VERSION > '3'
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

  module Moneys
    def self.macros
      [:value, :price, :cost]
    end

    macros.each do |klass|
      name = "#{klass}_class"

      # define getter
      define_singleton_method name do
        var_name = :"@#{name}"
        unless instance_variable_get(var_name)
          instance_variable_set(var_name, klass.to_s.camelize.constantize)
        end
        instance_variable_get(var_name)
      end
    end

    macros.each do |name|
      writ_klass = "#{name}_class"
      # define attr writer
      self.send(:attr_writer, writ_klass)
    end

    class << self
      def classes= klass
        macros.each {|m| send("#{m.to_s.underscore}_class=", klass) }
      end

      def macro_map
        {
          :costing => :cost,
          :priced_at => :price,
          :valued_at => :value
        }
      end
    end
  end
end  

class Object
  Mongoid::Moneys.macro_map.each do |method_name, klass|
    define_method method_name do |amount, currency=nil|
      currency = ::Money::Currency.new(currency || ::Money.default_currency)
      money = Money.new(amount, currency)

      class_name = "#{klass}_class"
      money_klass = Mongoid::Moneys.send(class_name)
      money_klass.new :price => money
    end
  end
end

