require 'card_pres'

describe 'CardPres' do

  describe '#initialize' do
    
    describe 'normally from strings' do
      let (:cp) {CardPres.new("user", "1", "1.3", "4")}
      it { cp.to_a.should == ["user",1,1.3,4] }
      it { cp.user_id.should == "user" }
      it { cp.total_count.should == 1 }
      it { cp.total_payment_amount.should == 1.3 }
      it { cp.card_present_count.should == 4 }
    end
    
    describe 'with integer string user_id and non-string other values' do
      let (:cp) {CardPres.new("1234",1,1.3,4)}
      it { cp.to_a.should == [1234,1,1.3,4] }
      it { cp.user_id.should == 1234 }
      it { cp.user_id.should_not == '1234' }
    end
    
    describe 'with Integer user_id' do
      let (:cpa) {CardPres.new(1234,1,1.3,4)}
      it { cpa.user_id.should == 1234 }
    end
    
  end
  
  describe '.from_raw_input_line' do
    it { CardPres.from_raw_input_line(" user , p, 123.45, 1, c\n").should == CardPres.new("user",1,123.45,1) }
  end
  
  let (:cp1a) { CardPres.new(1,  3, 1.3,  5) }
  let (:cp1b) { CardPres.new(1,  7, 2.0, 11) }
  
  describe '#<<' do
    it { cp1a<<cp1b; cp1a.to_a.should == [1,10,3.3,16]}
  end
  
  describe '#card_present_ratio' do
    it { cp1a.card_present_ratio.should == 5.0/3 }
  end
  
  describe '::Aggregator' do
    let (:cp1a) { CardPres.new(1,  3, 1.3,  5) }
    let (:cp1b) { CardPres.new(1,  7, 2.0, 11) }
    let (:cp2a) { CardPres.new(2, 13, 0.1, 17) }
    let (:cpag) { CardPres::Aggregator.new << cp1a }

    it "accepts a CardPres" do
      cpag.first.should == cp1a
    end
    
    it "aggregates CardPres objects, summing fields where user_id matches" do
      cpag << cp1b << cp2a
      cpag.map{|cp|cp.to_a}.should == [[1,10,3.3,16], [2,13,0.1,17]]
    end
    
    describe '#card_present_ratios_for_both_spending_buckets' do
      let (:cpag1) { CardPres::Aggregator.new }
      before do
        cpag1 << 
          CardPres.new(1,9,99,7) << 
          CardPres.new(2,17,101,13) << 
          CardPres.new(3,23,99,19)
      end
      
      it { cpag1.card_present_ratios_for_both_spending_buckets.map{|x|x.to_a.sort}.should == [[7.0/9, 19.0/23], [13.0/17]] }
    end
  end
end
