# Copyright © 2011 Timothy James; All rights reserved

# 
# cardp.rb - Bare functions to partition users and calculate the ECDFs given per-user aggregate data.
# 

def ecdfs_per_spending_bucket_for_aggregate_card_preses quantile_count, aggregate_card_preses
  card_present_ratios_for_each_spending_bucket(aggregate_card_preses).map do |spending_bucket|
    ecdf(quantile_count, spending_bucket.sort!)
  end
end

def card_present_ratios_for_each_spending_bucket aggregate_card_preses
  aggregate_card_preses.partition{|cp| cp.total_payment_amount < 100}.map{|bucket| bucket.map &:card_present_ratio} 

  # Note: see more complicated, more space efficient (but same space big-O) implementation at git commit 2e2dc64
end

def ecdf quantile_count, sorted_ratios
  ratio_map sorted_ratios.size, unscaled_ecdf(quantile_count, sorted_ratios)
end

def unscaled_ecdf quantile_count, sorted_ratios
  quantile_thresholds = (1..quantile_count).map{ |i| i / quantile_count.to_f }
  quantile_thresholds.map { |quantile_threshold|
    sorted_ratios.find_index { |ratio|
      ratio > quantile_threshold
    } or sorted_ratios.count
  }
end

def ratio_map denominator, values
  values.map { |v| v / denominator.to_f }
end
