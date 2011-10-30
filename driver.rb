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


demo = Demo.new(n_users:3000, n_payments:50000, stddev:0.15)
ecdf_for_triples(30, demo).each {|vs| puts "===="; puts vs.join("\n")}
