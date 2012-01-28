# Copyright © 2011 Timothy James; All rights reserved

# 
# Invoked from command line, performs all or phased actions to calculate and present ECDFs.
# Accepts from ARGV file names and name=value options.
# 

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
    if ['-h', '-help', '--help'].any? {|help_arg| ARGV.include? help_arg}
      puts "Please read README.rdoc"
      puts "Ideally with formatting at http://github.com/enthal/ecdf_ruby_demo"
      return
    end
    
    opts = optify @opts, action: :all, source:(ARGV.empty? ? :gaussian : :file)
  
    case opts.source
      when :gaussian
        card_preses = GaussianCardPresEnumerator.new @opts
      when :file
        card_preses = Parser.new ARGF
        if [:finish, :reaggregate].include? opts.action
          card_preses.use_aggregated_input
        end
    end
    
    if [:all, :aggregate, :reaggregate, :finish].include? opts.action
      card_preses = CardPres::Aggregator.new card_preses
    end
    
    if [:dump, :aggregate, :reaggregate].include? opts.action
      opts2 = optify @opts, outfile:(:dump==opts.action ? 'raw' : 'aggregate')+'.csv'
      write_card_preses card_preses, opts2.outfile, (:dump==opts.action ? :to_raw_input_line : :to_csv_line)
      return
    end
    
    if [:all, :finish].include? opts.action
      opts = optify @opts, quantiles:100
      lt100s, gt100s = ecdfs_per_spending_bucket_for_aggregate_card_preses opts.quantiles, card_preses
      output_ecdfs_for_lt100s_gt100s lt100s, gt100s
      return
    end
    
    raise "INVALID action (#{opts.action}); must one of: all, dump, aggregate, reaggregate, finish"
  end
  
  def write_card_preses card_preses, output_filename, method
    puts "Writing to #{output_filename} ..."
    File.open(output_filename, 'w') do |output_file|
      card_preses.each do |cp|
        output_file.puts cp.send(method)
      end
    end
    puts "DONE!"
  end

  def output_ecdfs_for_lt100s_gt100s lt100s, gt100s
    # Slavish and probably unneccesary devotion to output format stated in challenge
    puts "Users who processed less than $100"
    format_ecdf_as_required lt100s
    puts "\nUsers who processed over $100"
    format_ecdf_as_required gt100s
  end

  def format_ecdf_as_required ecdf_vector
    opts = optify @opts, graph:false
    
    # honest (perCENTile) only if ecdf_vector.size=100
    puts "percentile    % cp"
    
    ecdf_vector.each_with_index do |ratio_cp, i|
      begin
        percent_cp = (ratio_cp*100).to_i
      rescue FloatDomainError
        puts "EMPTY SPENDING BUCKET"  # happens when no users fall into this spending bucket
        return
      end
      percent_cp = '*'*percent_cp if opts.graph
      
      puts "#{i+1}\t      #{percent_cp}"
    end
  end
end


Driver.new.run
