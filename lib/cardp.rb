# Suppose you have multiple large files (on the order of 100GBs) containing tuples of the following form: 
# {user_id, payment_id, payment_amount, is_card_present, created_at}. 
# Write a program to compute the empirical cumulative distribution function of the card present ratio 
# for users who processed less than $100, and for users who processed over $100.
#  
# The expected output should be of the form:
#  
# Users who processed less than $100
# percentile    % cp
# 1             0
# 2             0
# 3             5
# ...           ...
# 100           100
#  
# and similarly for users who processed over $100.

# user_id, payment_id, payment_amount, is_card_present, created_at
data = "
  1 1 
"

def cp_data_row
  [rand(10), 'x', rand(200), rand(2), 'x']
end

psuedocode = <<-___ENDCODE
  parse: user_id, payment_amount, is_card_present
  sum: by user_id: payment_amount, is_card_present, count
  for each: f: {|x|x<100}, {|x|x>=100}:
    group 
    
___ENDCODE

def parse data
end

def total_by_first rows
  rows.reduce({}) { |groups_by_id, row| accumulate_by_first(groups_by_id ,row) }
end

def accumulate_by_first groups_by_id, row
  old_group = groups_by_id[row[0]] || [0]*row.length
  groups_by_id[row[0]] = old_group .zip([1]+row[1..-1]) .map {|a,b|a+b}
  groups_by_id
end

def card_present_ratios_for_both_spending_buckets groups_by_id
  lt100s = []; gt100s = []
  groups_by_id.each_value do |total_count, total_payment_amount, card_present_count|
    card_present_ratio = Float(card_present_count)/total_count
    (total_payment_amount<100 ? lt100s : gt100s) << card_present_ratio
  end
  [lt100s, gt100s]
end

def everything
  groups_by_id = total_by_first(parse(data))
  card_present_ratios_for_both_spending_buckets groups_by_id
end
