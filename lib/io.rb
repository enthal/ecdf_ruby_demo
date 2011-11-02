# Copyright © 2011 Timothy James; All rights reserved
require 'card_pres'

class Parser
  include Enumerable
  
  def initialize lines, quiet=false
    @lines = lines
    @quiet = quiet
    @line_parse_method = :from_raw_input_line
  end
  
  def use_aggregated_input
    @line_parse_method = :from_csv_line
  end
  
  def each
    @lines.each do |line|
      line.strip!
      unless line.empty?
        begin
          yield CardPres.send(@line_parse_method, line)
        rescue
          puts "Ignoring line: #{line}" unless @quiet
        end
      end
    end
  end
  
end

