class Price
	include Mongoid::Document

  monetizable :as => :priced

  def self.for amount, currency = nil
  	currency = ::Money::Currency.new(currency || ::Money.default_currency)
  	money = ::Money.new(amount, currency)

    # see 'kristianmandrup' fork of money (money/macros)
  	Mongoid::Money::Macros.price_class.new :price => money
  end
end
