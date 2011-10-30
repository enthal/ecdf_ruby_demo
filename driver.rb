# Copyright © 2011 Timothy James; All rights reserved
require './lib/cardp'
require './lib/distributions'
require './lib/util'


class Demo
  include Enumerable
  
  def initialize opts={}
    @opts = optify opts, { n_users:1000, n_payments:10000, stddev:0.25 }
    @user_card_probabilities = gaussian_probability_distribution(@opts.n_users, @opts.stddev)
  end
  
  def data_row
    # user_id, payment_amount, is_card_present
    user_id = rand(@opts.n_users)
    [
      user_id,
      rand(user_id/@opts.n_users.to_f*300 * (@opts.n_users/@opts.n_payments.to_f)),
      (rand > @user_card_probabilities[user_id])? 1:0,
    ]
  end
  
  def each
    @opts.n_payments.times { yield data_row }
  end
end

def format_ecdf_as_required ecdf_vector
  # honest (perCENTile) only if ecdf_vector.size=100
  puts "percentile    % cp"
  ecdf_vector.each_with_index do |ratio_cp, i|
    percent_cp = (ratio_cp*100).to_i
    puts "#{i+1}\t      #{percent_cp}"
  end
end

def do_all_as_required 
  demo = Demo.new(n_users:3000, n_payments:50000, stddev:0.15)
  lt100s, gt100s = ecdf_for_triples(100, demo)
  
  # Slavish and probably unneccesary devotion to output format stated in challenge
  
  puts "Users who processed less than $100"
  format_ecdf_as_required lt100s

  puts "\nUsers who processed over $100"
  format_ecdf_as_required gt100s
end

do_all_as_required
