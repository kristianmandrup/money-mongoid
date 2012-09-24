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

    def custom_between(field, value, options = {})
      { "$gte" => ::Money.new(value.min, value.iso_code), "$lte" => ::Money.new(value.max, value.iso_code) }
    end

    def custom_between? field, value
      true
    end

    private

    def specify_with_multiple_currencies(name, operator, value, options)
      currencies = [value.currency.iso_code]
      currencies.concat options[:compare_using] if options && options[:compare_using]
      multiple_money_values = value.exchange_to_currencies(currencies.to_set)
      subconditions = multiple_money_values.collect {|money| specify_with_single_currency(name, operator, money)}
      if subconditions.count > 0
        {"$or" => subconditions}
      else
        subconditions[0]
      end
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

  def exchange_to_currencies(currencies)
    currencies.map {|currency| exchange_to(currency)}
  end

end

Mongoid::Fields.option :compare_using do |model, field, value|
  value.each do |iso_code|
    unless Money::Currency.find(iso_code)
      raise ArgumentError, "Invalid ISO currency code: #{value}" 
    end
  end
end

require 'money/mongoid/3x/origin/selectable'