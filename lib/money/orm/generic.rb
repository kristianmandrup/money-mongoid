class Money
	module Orm
		module Generic
		  # Virtual price / currency attributes
		  module ClassMethods
			  def monetize_for *names
					options = names.last.kind_of?(Hash) ? names.delete(names.last) : {:as => :priced}
					names.each {|name| monetize name, options }
				end
			end
		  
		  def price
		    ::Money.new(self.price_pence, currency)
		  end
		  def price=(price)
		    self.price_pence = price.cents
		  end

		  def currency
		    ::Money::Currency.new(currency_iso)
		  end	
		end
	end
end