# extend Mongoid::Fields in Mongoid document (model) that wants to use Money
# this makes Money accessible as a type

module Mongoid
  module Fields
    class Money
      include Mongoid::Fields::Serializable
    
      def self.instantiate(name, options = {})
        super
      end

      def deserialize(value)
        ::Money.new value[:cents], value[:currency_iso]
      end

      def serialize(value)
        {:cents => value.cents, :currency_iso => value.currency.iso_code}
      end
    end
  end
end
