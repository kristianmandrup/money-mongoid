class Product
  include Mongoid::Document
  extend Mongoid::Fields # to make Money available!

  field :price, :type => Money
end
