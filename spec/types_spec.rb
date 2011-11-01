require 'types'

describe 'CardPres' do

  describe '#initialize' do
    
    describe 'normally from strings' do
      let (:cpa) {CardPres.new("user", "1", "1.3", "4")}
      it { cpa.to_a.should == ["user",1,1.3,4] }
      it { cpa.user_id.should == "user" }
      it { cpa.total_count.should == 1 }
      it { cpa.total_payment_amount.should == 1.3 }
      it { cpa.card_present_count.should == 4 }
    end
    
    describe 'with integer string user_id and non-string other values' do
      let (:cpa) {CardPres.new("1234",1,1.3,4)}
      it { cpa.to_a.should == [1234,1,1.3,4] }
      it { cpa.user_id.should == 1234 }
      it { cpa.user_id.should_not == '1234' }
    end
    
  end
  
end
