class Account
	include Mongoid::Document
  include Mongoid::Monetize

  monetize_for  :utility, :services

  embeds_one 		:deposit, 			:as => :priced  
  monetize_one 	:rental_price

  monetize 			:rent
  monetize_many :costs, :class_name => 'Price'
end
