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
