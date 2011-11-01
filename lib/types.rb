
class CardPres < Struct.new( "CardPresStruct",
    :user_id, :total_count, :total_payment_amount, :card_present_count )
  
  def initialize user_id, total_count, total_payment_amount, card_present_count
    super(
      (/^\d+$/ === user_id) ? user_id.to_i : user_id,
      total_count.to_i,
      total_payment_amount.to_f,
      card_present_count.to_i    )
  end
  
end


