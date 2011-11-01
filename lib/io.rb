# Copyright © 2011 Timothy James; All rights reserved

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
          line_parts = line.split(/ *, */)
          raise unless line_parts.size == 5
          user_id, payment_id, payment_amount, is_card_present, created_at = line_parts
          yield [user_id, payment_amount.to_f, is_card_present.to_i]
        rescue
          puts "Ignoring line: #{line}" unless @quiet
        end
      end
    end
  end
  
end

