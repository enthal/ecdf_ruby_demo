require 'cardp'

describe 'cardp' do
  describe '#parse' do
    it { parse '' }
    xit { parse("\na x 3 1 x\nb x 4 0 x\n").should == [['a',3,1],['b',4,0]] }
  end
  
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
      {1=>[9,1,7],2=>[17,999,13],3=>[23,1,19]} ).should == [[7.0/9,19.0/23], [13.0/17]] }
  end
  
end
