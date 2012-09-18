module Mongoize
  extend ActiveSupport::Concern
  # See http://mongoid.org/en/mongoid/docs/upgrading.html        

  def mongoize
    {'cents' => cents, 'currency_iso' => currency.iso_code}
  end

  module ClassMethods
    def demongoize(value)
      ::Money.new get_cents(value), get_currency(value)
    end

    def evolve(object)
      object.__evolve_to_money__.mongoize
    end

    def custom_serialization?(operator)
      return false unless operator
      case operator
        when "$gte", "$gt", "$lt", "$lte"
          true
      else
        false
      end
    end

    def custom_specify(name, operator, value, options = {})
      money = value.__evolve_to_money__
      case operator
        when "$gte", "$gt", "$lt", "$lte"
          specify_with_multiple_currencies(name, operator, money, options)
      else
        raise RuntimeError, "Unsupported operator"
      end
    end

    private

    def specify_with_multiple_currencies(name, operator, value, options)
      # TODO: add the code here to check which currencies should be used for comparision, in options["compare_using"]
      # and if need be, create the equivalent money objects (using the @bank exchange rates)
      # and call specify with_single_currency with each of them
      specify_with_single_currency(name,operator,value)
    end

    def specify_with_single_currency(name, operator, value)
      {"#{name}.cents" => {operator => value.cents}, "#{name}.currency_iso" => value.currency.iso_code}
    end

    def get_cents value
      value[:cents] || value['cents']
    end

    def get_currency value
      value[:currency_iso] || value['currency_iso']
    end

  end
end


class Money
  include Mongoize

  def __evolve_to_money__
    self
  end
end

Mongoid::Fields.option :compare_using do |model, field, value|
  # TODO: add some validation here to make sure the value is a valid ISO currency code
end