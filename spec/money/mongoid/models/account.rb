class Account
	include Mongoid::Document
  include Mongoid::Monetize

  monetize_for  :utility, :services

  embeds_one 		:deposit, 			:as => :priced  
  monetize_one 	:rental_price

  monetize_one 	:rent
  monetize_many :costs, :class_name => 'Price', :as => :costing
end
