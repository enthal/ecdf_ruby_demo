require 'io'

describe 'io' do

  describe 'Parser' do
    it { Parser.new([], true).entries.should == [] }
    it { Parser.new(["\n","a, x , 3 ,1, x\n"," b ,x,4,0,x\n"], true).entries.should == [['a',3.0,1],['b',4.0,0]] }
    it { Parser.new(["Nonsense\n","a, x , 3 ,1, x\n","ignore\n"], true).entries.should == [['a',3.0,1]] }
  end

end
