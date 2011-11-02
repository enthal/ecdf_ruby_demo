
class CardPres < Struct.new( "CardPresStruct",
    :user_id, :total_count, :total_payment_amount, :card_present_count )
  
  def initialize user_id, total_count, total_payment_amount, card_present_count
    super(
      user_id.to_i.to_s == user_id ? user_id.to_i : user_id,
      total_count.to_i,
      total_payment_amount.to_f,
      card_present_count.to_i    )
  end
  
  def self.from_raw_input_line line
    line_parts = line.split(/ *, */).map{|part|part.strip}
    raise "Bad raw line (need 5 parts): #{line}" unless line_parts.size == 5
    user_id, payment_id, payment_amount, is_card_present, created_at = line_parts
    CardPres.new(user_id, 1, payment_amount, is_card_present)
  end
  
  def << other
    raise "user_id mismatch (#{user_id} != #{other.user_id})" if self.user_id != other.user_id
    (1...self.size).each { |i| self[i] += other[i] }
  end
  
  def card_present_ratio
    self.card_present_count / self.total_count.to_f
  end
  
  class Aggregator
    include Enumerable
    
    def initialize
      @values_by_user_id = Hash.new { |h,k| h[k] = CardPres.new(k,0,0,0) }
    end
    
    def each
      @values_by_user_id.each_value { |x| yield x }
    end
    
    def << card_pres
      @values_by_user_id[card_pres.user_id] << card_pres
      self
    end
    
    # This might not be appropriate here, but with only the single given requirement 
    # there is no basis by which to divide out general and specific.
    def card_present_ratios_for_both_spending_buckets
      [true,false].map do |whether| 
        Enumerator.new do |y|
          self.each do |cp| 
            y << cp.card_present_ratio if whether == cp.total_payment_amount < 100
          end
        end
      end
    end
  end
end


