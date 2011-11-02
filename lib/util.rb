# Copyright © 2011 Timothy James; All rights reserved

def optify opts, defaults={}
  new_opts = Hash[defaults].update opts
  opts.delete_if {|k,v| defaults.include? k}  # delete accepted opts
  Struct.new(*new_opts.keys).new(*new_opts.values)
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
