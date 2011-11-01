
class CardPres < Struct.new( "CardPresStruct",
    :user_id, :total_count, :total_payment_amount, :card_present_count )
  
  def initialize user_id, total_count, total_payment_amount, card_present_count
    super(
      (/^\d+$/ === user_id) ? user_id.to_i : user_id,
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

end


