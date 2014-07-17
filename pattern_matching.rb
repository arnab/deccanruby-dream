#!/usr/bin/ruby -wKU

def sum(head, *tail)
  tail.empty? ?
    head : head + sum(*tail)
end

puts sum(1,2,3,4,5)
