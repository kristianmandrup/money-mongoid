# Thanks to: https://gist.github.com/840500

module Mongoid
	module Monetizable
		include ::Money::Orm::Generic

		def self.included(base)
			base.class_eval do
			  field :cents, 				:type => Integer, :default => 0
			  field :currency_iso, 	:type => String, 	:default => ::Money.default_currency.iso_code
			  
			  validates_numericality_of :cents
			end
			base.extend ::Money::Orm::Generic::ClassMethods				
		end
	end
end
