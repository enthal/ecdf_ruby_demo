require 'io'

describe 'io' do

  describe 'Parser' do
    it { Parser.new([], true).entries.should == [] }
    it { Parser.new([" "], true).entries.should == [] }
    it { Parser.new(["a,x,3.1,2,x\n"], true).entries.should == [CardPres.new("a",1,3.1,2)] }
    it { Parser.new(["\n","a, x , 3 ,1, x\n"," b ,x,4,0,x\n"],    true).map{|x|x.to_a}.should == [['a',1,3.0,1],['b',1,4.0,0]] }
    it { Parser.new(["Nonsense\n","a, x , 3 ,1, x\n","ignore\n"], true).map{|x|x.to_a}.should == [['a',1,3.0,1]] }
  end

end
