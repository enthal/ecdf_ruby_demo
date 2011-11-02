# Copyright © 2011 Timothy James; All rights reserved
require 'util'
require 'distributions'
require 'card_pres'

class GaussianCardPresEnumerator
  include Enumerable
  
  def initialize opts={}
    @opts = optify opts, { n_users:1000, n_payments:10000, stddev:0.25 }
    @user_card_probabilities = gaussian_probability_distribution(@opts.n_users, @opts.stddev)
  end
  
  def each
    @opts.n_payments.times { yield data_row }
  end
  
  private
  
  def data_row
    # user_id, payment_amount, is_card_present
    user_id = rand(@opts.n_users)
    [
      user_id,
      rand(user_id/@opts.n_users.to_f*300 * (@opts.n_users/@opts.n_payments.to_f)),
      (rand > @user_card_probabilities[user_id])? 1:0,
    ]
  end
  
end
