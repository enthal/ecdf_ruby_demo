# Copyright © 2011 Timothy James; All rights reserved

def optify opts={}, defaults={}
  unrecognized_opts = opts.keys - defaults.keys
  unless unrecognized_opts.empty?
    raise "Unrecognized opts: #{unrecognized_opts.join(', ')} (allowed: #{defaults.keys.join(', ')})"
  end
  
  opts = Hash[defaults].update opts
  Struct.new(*opts.keys).new(*opts.values)
end

def cull_argv_opts argv=ARGV
  new_argv = []
  opts = {}
  
  argv.each do |arg|
    if arg.include? '='
      k,v = arg.split('=', 2)
      opts.store(k.strip.to_sym, v)
    else
      new_argv << arg
    end
  end
  
  argv.clear.push *new_argv
  opts
end
