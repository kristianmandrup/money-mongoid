shared_examples 'a generic account' do
  it "rental is money" do
    subject.rental_price.price.should == Money.new(3000)
  end

  it "deposit is also money" do
    subject.deposit.price.should == Money.new(150)
  end

  it "and rent is also money" do
    subject.rent.price.should == Money.new(100)
  end
end