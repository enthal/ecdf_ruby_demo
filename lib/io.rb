# Copyright © 2011 Timothy James; All rights reserved
require 'card_pres'

class Parser
  include Enumerable
  
  def initialize lines, quiet=false
    @lines = lines
    @quiet = quiet
  end
  
  def each
    @lines.each do |line|
      line.strip!
      unless line.empty?
        begin
          yield CardPres.from_raw_input_line line
        rescue
          puts "Ignoring line: #{line}" unless @quiet
        end
      end
    end
  end
  
end

