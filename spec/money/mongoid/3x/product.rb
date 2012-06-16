class Product
  include Mongoid::Document

  field :price, :type => Money

  def exchange_to! currency_iso
    self.price = self.price.exchange_to(currency_iso)
    save
  end
end
