require 'cardp'

describe 'cardp' do
  describe '#parse' do
    it { parse '' }
    xit { parse("\n1 x 3 1 x\n2 x 4 0 x\n").should == [[1,3,1],[2,4,0]] }
  end
end
