# Copyright © 2011 Timothy James; All rights reserved
require 'cardp'

describe 'cardp' do
  
  describe '#card_present_ratios_for_both_spending_buckets' do
    let (:cpag) { CardPres::Aggregator.new }
    before do
      cpag << 
        CardPres.new(1,9,99,7) << 
        CardPres.new(2,17,101,13) << 
        CardPres.new(3,23,99,19)
    end
    
    it { card_present_ratios_for_both_spending_buckets(cpag).map{|x|x.to_a.sort}.should == [[7.0/9, 19.0/23], [13.0/17]] }
  end
  
  describe '#unscaled_ecdf' do
    it { unscaled_ecdf(100, []) }
    it { unscaled_ecdf(3, [0.5,0.5]).should == [0,2,2] }
    it { unscaled_ecdf(3, [0.5,0.8]).should == [0,1,2] }
    it { unscaled_ecdf(4, [0.1, 0.85]).should == [1,1,1,2] }
    it { unscaled_ecdf(4, [0.1, 0.3,0.4,0.45,0.5, 0.55,0.67, 0.85]).should == [1,5,7,8] }
  end
  
  describe '#ratio_map' do
    it { ratio_map(10,[0,1,5,10]).should == [0,0.1,0.5,1]}
    it { ratio_map(5,[2]).should == [2.0/5]}
    it { ratio_map(nil,[]).should == []}
  end
  
end
