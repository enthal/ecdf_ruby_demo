
def optify opts={}, defaults={}
  unrecognized_opts = opts.keys - defaults.keys
  unless unrecognized_opts.empty?
    raise "Unrecognized opts: #{unrecognized_opts.join(', ')} (allowed: #{defaults.keys.join(', ')})"
  end
  
  opts = Hash[defaults].update opts
  Struct.new(*opts.keys).new(*opts.values)
end
