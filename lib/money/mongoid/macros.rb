module Mongoid
	module Money	
		module Macros
			def self.included(base)
				base.send :include, ClassMethods
			end

			module ClassMethods
				def monetize
					self.send :include, "Mongoid::Monetize".constantize						
				end

				def monetizable options = {}
					self.send :include, "Mongoid::Monetizable".constantize
					embedded_in options[:as], :polymorphic => true if options[:as]
				end
			end
		end
	end
end

module Mongoid
	module Document
		module ClassMethods
			include Money::Mongoid::Macros			
		end
	end
end

