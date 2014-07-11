![650%](~/Downloads/requiem_for_a_dream.jpg)

---

# @arnab_deka

^ Live in Bangalore

---

# Pune

^ First job, first bike, first serious relationship.

---

Jagtap Diary

---

# [fit] nilenso

^ Work on Clojure. Also play with Elixir and everything else.
^ This talk brings some of the inspirations from those technologies
into Ruby.

---

# [fit] Tail Call Optimization

---

## TCO

```rb
def foo(x)
  # do some other things
  9 + bar(x)
end
```

---

## TCO

```rb
def foo(x)
  # do some other things
  bar(9 + x)
end
```

---

## TCO back in the days of...

+ CommonLisp
+ Scheme
+ ...

^ So idea was first used in Lisps. Scheme makes it mandatory.
^ JVM does not support tails calls but some JVM languages work around that.

---

## TCO in Scala

`@tailrec`

^ Annotation based. Turns it into a loop: so optimized at compile time.

---

## TCO in Clojure

`loop/let/recur`

^ Same idea as scala: non-stack-consuming looping construct

---

## Fibonnacci

```ruby
def fib(n)
  n.zero? ? 1 : (n * fib(n-1))
end
```

---

## Fibonnacci

```ruby
n * fib(n-1)
```

^ Demo: 8733

---

## Fibonnacci

`SystemStackError: stack level too deep`

---

## Fibonnacci

```ruby
def fib(n, acc=1)
  n.zero? ? acc : fib(n-1, n*acc)
end
```

^ Demo: 8733

---

## Fibonnacci

`SystemStackError: stack level too deep`

---

## Fibonnacci

```ruby
RubyVM::InstructionSequence.compile_option = {
  :tailcall_optimization => true,
  :trace_instruction => false
}

```

---

## Fibonnacci

```ruby
source = <<-SOURCE
def fib(n, acc=1)
  n.zero? ? acc : fib(n-1, n*acc)
end

puts fib(20_000)
SOURCE
```

---

## Fibonnacci

```ruby
iseq = RubyVM::InstructionSequence.new(source)
iseq.eval
```

^ Demo
^ Talk about JRuby and mention Clojure/Scala

---

# [fit] Destructuring

---
