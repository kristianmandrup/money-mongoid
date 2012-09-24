require 'money/mongoid/spec_helper'
require 'money/mongoid'
require 'money/mongoid/3x/product'

describe 'Mongoid custom Money type' do
  subject { product }

  let(:product) { Product.create(:price => Money.new(3000, 'USD')) }
  let(:products) do 
  end

  before :all do
    # Mongoid.logger = Logger.new($stdout)
    # Moped.logger   = Logger.new($stdout)

    Money.add_rate("USD","EUR", 0.5)
    Money.add_rate("EUR","USD", 2)
  end

  def create_money iso_code, count = 6, options = {step: 500}
    step = options[:step]
    count.times do |n|
      Product.create :price => Money.new(n * step, iso_code)
    end
  end


  its(:price) { should be_a Money }

  specify { subject.price.cents.should == 3000 }
  specify { subject.price.currency.iso_code.should == 'USD' }

  it "should be searchable by price as money" do
    Product.create(:price => Money.new(3000, 'USD'))
    Product.where(price: Money.new(3000, 'USD')).count.should == 1
  end

  it "should be searchable by price as string" do
    product
    Product.where(price: "USD 30.00").count.should == 1
  end

  it "should be searchable by price using gte and a money value of same currency" do
    product
    Product.where(:price.gte => Money.new(2000, 'USD')).count.should == 1
  end

  it "should be searchable by price using gte and a money value of different currency" do
    create_money 'USD'

    # So far only works by explicit conversion before search. Any solution?    
    Product.all.exchange_to! 'EUR'

    # puts Product.all.map{|p| p.price.inspect }

    # with our rates 20 EUR -> 40 USD
    search_res = Product.where :price.gte => Money.new(2000, 'EUR')
    search_res.count.should == 0
  end

  it 'should search using money range' do
    create_money 'USD'

    res1 = Product.between price: (500..2000).dollars
    res2 = Product.between price: (500..2000).to_currency('USD')

    res1.count.should == 4
    res2.count.should == res1.count

    res3 = Product.between price: Money.range((500..2000), 'usd')
    res3.count.should == 4
  end


  it "should respect the currency information when using comparison operators" do
    create_money 'USD'
    create_money 'EUR'

    search_res = Product.where :price.gte => Money.new(2000, 'EUR')
    search_res.count.should == 2
    search_res = Product.where :price.lt => Money.new(2000, "USD")
    search_res.count.should == 6

  end
end
