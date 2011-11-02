# Copyright © 2011 Timothy James; All rights reserved
$LOAD_PATH << File.join(File.dirname(__FILE__), 'lib')
require 'cardp'
require 'util'
require 'random'
require 'io'

class Driver
  def initialize
    @opts = cull_argv_opts
  end
  def run
    opts = optify @opts, action: :all, source:(ARGV.empty? ? :gaussian : :file)
  
    card_preses = case opts.source
      when :gaussian
        GaussianCardPresEnumerator.new @opts
      when :file
        Parser.new ARGF
    end
    
    if opts.action == :dump
      opts = optify @opts, dump_file:'dump.csv'
      File.open(opts.dump_file, 'w') do |dump_file|
        card_preses.each do |cp|
          dump_file.puts cp.to_raw_input_line
        end
      end
      return
    end
    
    output_ecdfs_for_lt100s_gt100s *(ecdfs_per_spending_bucket_for_raw_card_preses card_preses)
  end

  def ecdfs_per_spending_bucket_for_raw_card_preses raw_card_preses
    opts = optify @opts, percentiles:100
    aggregate_card_preses = CardPres::Aggregator.new raw_card_preses
    lt100s, gt100s = ecdfs_per_spending_bucket_for_aggregate_card_preses opts.percentiles, aggregate_card_preses
  end

  def output_ecdfs_for_lt100s_gt100s lt100s, gt100s
    # Slavish and probably unneccesary devotion to output format stated in challenge
    puts "Users who processed less than $100"
    format_ecdf_as_required lt100s
    puts "\nUsers who processed over $100"
    format_ecdf_as_required gt100s
  end

  def format_ecdf_as_required ecdf_vector
    # honest (perCENTile) only if ecdf_vector.size=100
    puts "percentile    % cp"
    ecdf_vector.each_with_index do |ratio_cp, i|
      begin
        percent_cp = (ratio_cp*100).to_i
      rescue FloatDomainError
        puts "EMPTY SPENDING BUCKET"  # happens when no users fall into this spending bucket
        return
      end
      puts "#{i+1}\t      #{percent_cp}"
    end
  end
end


Driver.new.run
