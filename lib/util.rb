# Copyright © 2011 Timothy James; All rights reserved

class Struct
  def to_hash
    Hash[*members.zip(values).flatten]
  end
end

def optify opts, defaults
  accepted_opts = Hash[ defaults.map{ |k,v| 
    [k, convert_from_string_to_match(opts[k]||defaults[k], defaults[k])]
    } ]
  opts.delete_if {|k,v| accepted_opts.include? k}
  Struct.new(*accepted_opts.keys).new(*accepted_opts.values)
end

def convert_from_string_to_match string, other
  return string unless string.is_a? String
  
  return case other
  when String
    string
  when Integer
    string.to_i
  when Float
    string.to_f
  when TrueClass
    string=='true'
  when FalseClass
    string=='true'
  end
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
