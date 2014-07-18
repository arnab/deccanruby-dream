n = ARGV.first.to_i

def fib_tailrec(n, acc=1)
  n.zero? ? acc : fib_tailrec(n-1, n*acc)
end

puts "fib_tailrec(#{n}) => #{fib_tailrec(n)}"
