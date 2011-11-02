# Copyright © 2011 Timothy James; All rights reserved

class Struct
  def to_hash
    Hash[*members.zip(values).flatten]
  end
end

class String
  def convert_to_type_of other
    return case other
    when String
      self
    when Integer
      to_i
    when Float
      to_f
    when TrueClass
      self=='true'
    when FalseClass
      self=='true'
    end
  end
end

def optify opts, defaults
  accepted_opts = Hash[ defaults.map{ |k, v|
    v = String===opts[k] ? opts[k].convert_to_type_of(v) : opts[k]  if opts.include? k
    [k, v]
    } ]
  opts.delete_if {|k,v| accepted_opts.include? k}
  Struct.new(*accepted_opts.keys).new(*accepted_opts.values)
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
