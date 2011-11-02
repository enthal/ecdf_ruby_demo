require 'card_pres'

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
    
    describe 'with Integer user_id' do
      let (:cpa) {CardPres.new(1234,1,1.3,4)}
      it { cpa.user_id.should == 1234 }
    end
    
  end
  
  describe '.from_raw_input_line' do
    it { CardPres.from_raw_input_line(" user , p, 123.45, 1, c\n").should == CardPres.new("user",1,123.45,1) }
  end
  
end
