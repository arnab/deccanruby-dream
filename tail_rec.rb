#!/usr/bin/ruby -wKU

# def bar(n)
#   foo(n-1)
# end

# def foo(n)
#   raise "boom" if n <= 7
#   bar(n - 1)
# end

# foo(15)

# RubyVM::InstructionSequence.compile_option = {
#   :tailcall_optimization => true,
#   :trace_instruction => false
# }

# source = <<-SOURCE
# def bar(n)
#   foo(n-1)
# end

# def foo(n)
#   raise "boom" if n <= 7
#   bar(n - 1)
# end

# foo(15)
# SOURCE

# iseq = RubyVM::InstructionSequence.new(source)
# iseq.eval

n = ARGV.first.to_i

################
#### Part 1 ####
################

def fib(n)
  n.zero? ? 1 : (n * fib(n-1))
end

puts "fib(#{n}) => #{fib(n)}"
# 8733: stack level too deep (SystemStackError)

################
#### Part 2 ####
################

def fib_tailrec(n, acc=1)
  n.zero? ? acc : fib_tailrec(n-1, n*acc)
end

puts "fib_tailrec(#{n}) => #{fib_tailrec(n)}"
# # 8734: stack level too deep (SystemStackError)

################
#### Part 3 ####
################

RubyVM::InstructionSequence.compile_option = {
  :tailcall_optimization => true,
  :trace_instruction => false
}

source = <<-SOURCE
def fib_tailrec(n, acc=1)
  n.zero? ? acc : fib_tailrec(n-1, n*acc)
end

puts fib_tailrec(20_000)
SOURCE

iseq = RubyVM::InstructionSequence.new(source)
# puts iseq.disasm
iseq.eval
# # # 20_000: stack level too deep (SystemStackError)
