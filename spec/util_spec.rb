# Copyright © 2011 Timothy James; All rights reserved
require 'util'

describe 'util' do
  
  describe '#cull_argv_opts' do
    let (:argv) { ['abc', 'a=b', '___', ' x = y = z ', '123'] }
    it { cull_argv_opts(argv).should == {a:'b', x:' y = z '} }
    it { cull_argv_opts(argv);  argv.should == ['abc', '___', '123'] }
  end

end
