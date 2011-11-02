# Copyright © 2011 Timothy James; All rights reserved
require 'util'

describe 'util' do
  
  describe '#cull_argv_opts' do
    let (:argv) { ['abc', 'a=b', '___', ' x = y = z ', '123'] }
    it { cull_argv_opts(argv).should == {a:'b', x:' y = z '} }
    it { cull_argv_opts(argv);  argv.should == ['abc', '___', '123'] }
  end
  
  describe '#optify' do
    it 'culls given or defaulted opts for keys in defaults' do
      opts = {a:'9',b:'7.1',d:333,s:'S',z:'xx'}
      optify(opts, {a:1,b:2.0,c:3.0,d:0,s:'ssss'}).to_hash.should == {a:9,b:7.1,c:3.0,d:333,s:'S'}
    end
  end

  describe String do
    describe '#convert_to_type_of' do
      it {   'a'.convert_to_type_of('b').should == 'a' }
      
      it {   'a'.convert_to_type_of(:b).should == :a }
      
      it {   '2'.convert_to_type_of(1).should == 2 }
      it {   '2'.convert_to_type_of(1.0).should == 2.0 }
      it { '2.1'.convert_to_type_of(1.0).should == 2.1 }
      
      it { 'false'.convert_to_type_of(true) .should == false }
      it { 'true' .convert_to_type_of(false).should == true }
    end
  end
  
end
