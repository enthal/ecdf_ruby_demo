# Copyright © 2011 Timothy James; All rights reserved
    
def card_present_ratios_for_both_spending_buckets card_preses
  card_preses.partition{|cp| cp.total_payment_amount < 100}.map{|bucket| bucket.map &:card_present_ratio} 

  # Note: see more complicated, more space efficient (but same space big-O) implementation at git commit 2e2dc64
end
 
def unscaled_ecdf interval_count, sorted_ratios
  interval_thresholds = (1..interval_count).map{ |i| i / interval_count.to_f }
  interval_thresholds.map { |interval_threshold|
    sorted_ratios.find_index { |ratio|
      ratio > interval_threshold
    } or sorted_ratios.count
  }
end

def ratio_map denomitator, values
  values.map { |v| v / denomitator.to_f }
end

def ecdf interval_count, sorted_ratios
  ratio_map sorted_ratios.size, unscaled_ecdf(interval_count, sorted_ratios)
end

def ecdfs_per_spending_bucket_for_card_preses interval_count, card_preses
  card_present_ratios_for_both_spending_buckets(card_preses).map do |spending_bucket|
    ecdf(interval_count, spending_bucket.sort!)
  end
end
 
