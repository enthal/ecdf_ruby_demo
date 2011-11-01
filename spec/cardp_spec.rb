# Copyright © 2011 Timothy James; All rights reserved
require 'cardp'

describe 'cardp' do
  
  describe '#total_by_first' do
    it { total_by_first([[3,300,1], [5,400,0], [3,10,0], [3,4,1]]).should == {3=>[3,314,2], 5=>[1,400,0]} }
  end
  
  describe '#accumulate_by_first' do
    it { accumulate_by_first({},[6,7,8]).should == {6=>[1,7,8]} }
    it { accumulate_by_first({6=>[1,7,8]}, [10,11,12]).should == {6=>[1,7,8],10=>[1,11,12]} }
    it { accumulate_by_first({6=>[1,7,8],10=>[1,11,12]}, [6,100,200]).should == {6=>[2,107,208],10=>[1,11,12]} }
  end
  
  describe '#card_present_ratios_for_both_spending_buckets' do
    it { card_present_ratios_for_both_spending_buckets(
      {1=>[9,99,7],2=>[17,101,13],3=>[23,99,19]} ).should == [[7.0/9,19.0/23], [13.0/17]] }
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
