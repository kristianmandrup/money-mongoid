class Money
	module Orm
		module Generic
		  # Virtual price / currency attributes
		  module ClassMethods
			  def monetize_for *names
					options = names.extract_options!
					options = {:as => :priced} if options.blank?			
					names.each do |name| 
						monetize_one name, options.dup
					end
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