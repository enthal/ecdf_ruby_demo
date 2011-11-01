# Copyright © 2011 Timothy James; All rights reserved

def parse data
end

def total_by_first rows
  rows.reduce({}) { |groups_by_id, row| accumulate_by_first(groups_by_id, row) }
end

def accumulate_by_first groups_by_id, row
  old_group = groups_by_id[row[0]] || [0]*row.length
  groups_by_id[row[0]] = old_group .zip([1]+row[1..-1]) .map {|a,b|a+b}
  groups_by_id
end

def card_present_ratios_for_both_spending_buckets groups_by_id
  lt100s = []; gt100s = []
  groups_by_id.each_value do |total_count, total_payment_amount, card_present_count|
    card_present_ratio = card_present_count/total_count.to_f
    (total_payment_amount<100 ? lt100s : gt100s) << card_present_ratio
  end
  [lt100s, gt100s]
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

def ecdfs_for_triples interval_count, triples
  groups_by_id = total_by_first(triples)
  card_present_ratios_for_both_spending_buckets(groups_by_id).map do |spending_bucket|
    ecdf(interval_count, spending_bucket.sort!)
  end
end
 
