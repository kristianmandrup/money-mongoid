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

    private

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