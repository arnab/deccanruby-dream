n = ARGV.first.to_i

def fib(n)
  n.zero? ? 1 : (n * fib(n-1))
end

puts "fib(#{n}) => #{fib(n)}"
