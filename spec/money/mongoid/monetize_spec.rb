require 'money/mongoid/spec_helper'

describe Money::Mongoid::Monetizable do
  before do
  	Money.default_currency = 'USD'
  end

  describe "monetize" do
  	subject { account }

    let(:account) do
      Account.create 	:rental_price => Price.for(3000, :usd), 
      								:deposit => Price.for(150, :usd), 
      								:rent => Price.for(100),
                      :utility => priced_at(200),
                      :services => priced_at(150)
    end


    it_behaves_like 'a generic account'

    context 'can add multiple costs' do    	
    	before do
    		account.costs << Price.for(100, :usd)
    		account.costs << Price.for(200)
    	end

    	its(:costs) { should have(2).items }
    end

    describe 'money macros' do
      subject { account_2 }

      let(:account_2) do
        Account.create  :rental_price => priced_at(3000, :usd), 
                        :deposit => priced_at(150, :usd), 
                        :rent => priced_at(100)
      end

      it_behaves_like 'a generic account'    
    end

    describe 'customize macro map' do
      context 'set cost_class to Price' do
        subject { cost_account }

        before do
          MoneyRails::Moneys.cost_class = Price
        end

        let(:cost_account) do
          Account.create  :rental_price => costing(3000, :usd)
        end

        it "rental is money" do
          subject.rental_price.price.should == Money.new(3000)
        end

        it "price compare < Numeric" do
          subject.rental_price.price.should < 3100
        end

        it "price compare == Numeric" do          
          subject.rental_price.price.should be_eql(3000)
        end

        it "price compare > Numeric" do
          subject.rental_price.price.should_not > 3001
        end
      end

      context 'set all money classes to Price' do
        subject { valued_at(4000) }

        before do
          MoneyRails::Moneys.classes = Price
        end

        specify { MoneyRails::Moneys.value_class.should == Price }

        specify { subject.should be_a Price }
        specify { subject.price.should be_a Money }
        specify { subject.price.should == Money.new(4000) }
      end
    end
  end
end
