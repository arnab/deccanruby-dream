#!/usr/bin/ruby -wKU

class Drink
  def gulp!
    "hic!"
  end
end

drinks = [Drink.new, Drink.new, Drink.new]

drinks.map { |d| d.gulp! } # hic! hic! hic!

# does not work
# drinks.map(gulp!)

# does not work either
# m = drinks.last.method(:gulp!)
# puts drinks.map { Proc.new {m} }

mult = lambda { |a,b| a * b }
  # => #<Proc:0x007ff2ec04fb00@(irb):3 (lambda)>

times_five = mult.curry[5]
  # => #<Proc:0x007ff2ec02d140 (lambda)>

times_five[10]
  # => 50

puts [1,2,3,4,5].map(&times_five)
