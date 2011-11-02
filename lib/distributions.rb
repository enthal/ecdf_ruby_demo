

def simple_gaussian mean, stddev
  # simplification of http://stackoverflow.com/questions/5825680/code-to-generate-gaussian-normally-distributed-random-numbers-in-ruby/6178290#6178290
  
  theta = 2 * Math::PI * rand
  rho = Math.sqrt(-2 * Math.log(1 - rand))
  scale = stddev * rho
  mean + scale * Math.sin(theta)
end

def gaussian_probability_distribution count, stddev
  (0..count).map { v = simple_gaussian(0.5, stddev) until (0..1).include? v; v }
end


