module Mongoid
	module Monetize
		def self.included(base)
			base.extend ClassMethods				
			base.extend Money::Orm::Generic::ClassMethods
		end

		module ClassMethods
			def monetize_one name, options = {:as => :priced}
				as_poly = options.delete(:as) || default_polymorphic_money
				
				unless as_poly
					raise ArgumentError, "You must set an :as option indicating the polymorphic Monetizable model. See money-rails gem."
				end

				self.embeds_one name.to_sym, options.merge(:as => as_poly)
			end
			alias_method :monetize, :monetize_one

			def monetize_many name, options = {:as => :priced}
				as_poly = options.delete(:as) || default_polymorphic_money
				unless as_poly
					raise ArgumentError, "You must set an :as option indicating the polymorphic Monetizable model. See money-rails gem."
				end					
				self.embeds_many name, options.merge(:as => as_poly)
			end

			protected

			def default_polymorphic_money
				Mongoid::Money.default_polymorphic_money
			end
		end # module			 
	end
end
