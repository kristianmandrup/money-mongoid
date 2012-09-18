class Product
  include Mongoid::Document

  field :price, :type => Money, :compare_using => ["USD", "EUR", "GBP"]

  def exchange_to! currency_iso
    self.price = self.price.exchange_to(currency_iso)
    save
  end
end
