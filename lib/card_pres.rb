
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
    self.total_count          += other.total_count
    self.total_payment_amount += other.total_payment_amount
    self.card_present_count   += other.card_present_count
    self
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
  end
end

