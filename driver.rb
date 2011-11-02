# Copyright © 2011 Timothy James; All rights reserved
$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require 'cardp'
require 'util'
require 'random'


def format_ecdf_as_required ecdf_vector
  # honest (perCENTile) only if ecdf_vector.size=100
  puts "percentile    % cp"
  ecdf_vector.each_with_index do |ratio_cp, i|
    percent_cp = (ratio_cp*100).to_i
    puts "#{i+1}\t      #{percent_cp}"
  end
end

def do_all_as_required 
  card_preses = GaussianCardPresEnumerator.new(n_users:3000, n_payments:50000, stddev:0.15)
  card_pres_aggregator = CardPres::Aggregator.new
  card_preses.each{|cp| card_pres_aggregator << cp}
  lt100s, gt100s = ecdfs_per_spending_bucket_for_card_preses(100, card_pres_aggregator)
  
  # Slavish and probably unneccesary devotion to output format stated in challenge
  
  puts "Users who processed less than $100"
  format_ecdf_as_required lt100s

  puts "\nUsers who processed over $100"
  format_ecdf_as_required gt100s
end

do_all_as_required
