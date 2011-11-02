# Copyright © 2011 Timothy James; All rights reserved
require 'random'

describe 'random' do
  
  describe GaussianCardPresEnumerator do
    let(:gcpe) { GaussianCardPresEnumerator.new(n_payments: 5) }
    
    it { gcpe.entries.size.should == 5 }
  end
end
