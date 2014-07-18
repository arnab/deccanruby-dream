![650%](http://f.cl.ly/items/323l2x0G2d2d2a1r381x/requiem_for_a_dream.jpg)

^ Live in Bangalore

---

![fit](http://2.bp.blogspot.com/-x21Y6ZOGU4w/UFjaXpxRPtI/AAAAAAAAAG0/RnIeoFcwY9M/s1600/Pune-136aa.jpg)

^ First job, first bike, first bike accident, first serious relationship.

---

![](http://modernfarmer.com/wp-content/uploads/2014/03/water-buff-hero1.jpg)

---

![fit](http://chaneyarchitects.com/wp-content/uploads/2013/03/Amar-Renaissance-view-of-building-A-B-C-700x466.jpg)

---

![fit](http://f.cl.ly/items/2Z2n2b0S0S1X0E3k2w3X/Screen%20Shot%202014-07-17%20at%2011.08.30%20am.png)

^ Work on Clojure. Also play with Elixir and everything else.
^ This talk brings some of the inspirations from those technologies
into Ruby.

---

# [fit] Tail Call Optimzation

^ What is TCO? function call in tail position, can replace the
stack frame, avoiding stack overflow and making it fast.

---

## TCO

```ruby
                  def bar(n)
                    foo(n-1)
                  end

                  def foo(n)
                    raise "boom" if n <= 7
                    bar(n - 1)
                  end
```

---

## TCO

_foo(15)_

---

## TCO

```
          tail_rec.rb:8:in `foo': boom (RuntimeError)
          		from tail_rec.rb:4:in `bar'
          		from tail_rec.rb:9:in `foo'
          		from tail_rec.rb:4:in `bar'
          		from tail_rec.rb:9:in `foo'
          		from tail_rec.rb:4:in `bar'
          		from tail_rec.rb:9:in `foo'
          		from tail_rec.rb:4:in `bar'
          		from tail_rec.rb:9:in `foo'
          		from tail_rec.rb:12:in `<main>'
```

---

## TCO

```
          <compiled>:2:in 'foo': boom (RuntimeError)
           		from tail_rec.rb:25:in 'eval'
           		from tail_rec.rb:25:in '<main>'
```

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

---

## Fibonnacci

```ruby
                    fib(n-1, n*acc)
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

^ Practical? Recursive elegant solutions.

---

# [fit] Pattern Matching

---

## in Ruby

```ruby
              a, b, c, d = [1 200 32 65.45]


              first, *rest = [1 200 32 65.45]
```

---

## Ruby: `splat`/`slurp`

```ruby
              def stats(*nums)
                [nums.min, nums.max]
              end

              stats(1,2,3,-100,100_0000)
```

---

## Ruby: `splat`/`split`

```ruby
                    def add(a,b)
                      a + b
                    end

                    add(*[1, 300])
```

---

## in Ruby

```ruby
            dogs = {
              snowy: 'fox terrier',
              laika: 'mongrel'
            }

            dogs.each do |name, breed|
              puts "#{name} was a #{breed}"
            end
```

---

## in Clojure

```clojure
            (def things [1 200 32 65.45])

            (let [[a b c d] things]
              ( + a d))

            ;; 64
```

---

## in Elixir

```elixir
                      defmodule MyNums
                        def sum([]) do
                          0
                        end

                        def sum([hd|tl]) do
                          hd + sum(tl)
                        end
                      end

                      MyNums.sum([1,2,3,4,5)] # 15
```

---

## in Clojure

```clojure
                (defn sum [[x & xs]]
                  (if (seq xs)
                      (+ x (sum xs))
                      x))

                (sum [1 2 3 4 5]) ;; 15
```

---

## in Ruby

```ruby
                def sum(head, *tail)
                  tail.empty? ?
                    head : head + sum(*tail)
                end

                sum(1,2,3,4,5) # 15
```

---

## But... in Elixir

```elixir
                      iex> a = 1
                      1

                      iex> 1 = a
                      1
```

---

## But... in Elixir


```elixir
                      iex> 2 = a
```

`(MatchError)`
`no match of right hand side value: 1`

^ But in pattern matching languages, destructuring is more than just
syntax sugar

---

### [fit] Destructuring
### is
## [fit] **EVERYWHERE**

---

## Destructuring maps

```clojure
        (def div-attrs {:id        "table-123"
                        :css-class "table highlight"})

        (let [{i :id c :css-class} div-attrs]
          (str "<div id='" i "' class='" c "'></div>"))

        ;; "<div id='table-123' class='table highlight'></div>"
```

---

## Destructuring maps

```clojure
        (let [:keys {id css-class} div-attrs]
          ;; use id and css-class )
```

---

## Deep destructuring

```clojure
               (def m {:a 5 :b 6
                       :c [7 8 9]
                       :d {:e 10 :f 11}})
               (let [{a :a
                      b :b
                      {e :e} :d} m]
                 (+ a b e)) ;; 21
```

^ And not only this you can match in any data structure, be it a
^ list/map/set or a mix of all that

^ Think how clutter-free Rails options hash parsing would become.

^ In fact this is so common

---

## Deep destructuring

```clojure
                (def famous-dogs
                  [["snowy" 1929
                    :breed "fox terrier"
                    :location "Belgium"]
                  ["laika" 1954
                    :breed "mongrel"
                    :location "USSR"]])
```

^ Let's see how we can use pattern matching to process this data structure.
^ Because matching is so easy, it's common to see such data structures.

---

## Deep destructuring

`[x & xs]` matches a list or a vector

---

## Deep destructuring

`[dog & more-dogs]` matches `famous-dogs`

^ Now concentrate on the dog, and forget the rest of the dogs

---

## Deep destructuring

Each `dog` is like:

```clojure
                     ["snowy" 1929
                      :breed "fox terrier"
                      :location "Belgium"]
```

* `[name year & more]` matches a `dog`

---

## Deep destructuring

At this point, `more` is like:

```clojure
                 [:breed "fox terrier"
                  :location "Belgium"]
```

`(apply hash-map more)`
is matched to
`{:keys [breed location]}`

---

## Deep destructuring

`(seq more-dogs)`

and

`(recur more-dogs)`

^ seq: remaining sequence of dogs, or nil
^ recur: rebinds the loop with the remaining dogs. Remember TCO?

^ So putting this all together...

---

## Deep destructuring

```clojure
          (loop [[[name year & more] & more-dogs]
                 famous-dogs]
            (let [{:keys [breed location]}
                  (apply hash-map more)]
              (prn (format
                    "%s is a %s, born in %d in %s."
                    name breed year location)))
            (if (seq more-dogs) (recur more-dogs)))

          ;; snowy is a fox terrier, born in 1929 in Belgium.
          ;; laika is a mongrel, born in 1954 in USSR.

```

---

## in Ruby's Future?

Feature Request **#8895**
[https://bugs.ruby-lang.org/issues/8895](https://bugs.ruby-lang.org/issues/8895)

```ruby
          params = {name: "John Smith", age: 42}
          {name: name, age: age} = params
```

---

![fit](http://f.cl.ly/items/1V1Q213I2B3d111Z0u3U/Screen%20Shot%202014-07-18%20at%2019.32.03%20pm.png)

---

# [fit] Higher Order Functions

---

## HOFs in Ruby?

```ruby
                drinks.map { |d| d.gulp! }


                add = lambda { |a,b| a + b }
                add.call(1,3) # => 4
```

^ So we have lambdas or blocks. And they are one of the most beautiful
parts of Ruby. And this is what had me hooked on, initially, coming
from Java.

---

## HOFs in Ruby?

```ruby
                  m = 1.method(:+)
                    # => #<Method: Fixnum#+>
```

^ We can get a handle on methods

---

## HOFs in Ruby?

```ruby
                  m.class.name # => Method

                  m.methods.size # => 66
```

^ and can ask it questions, just like any object.

---

## HOFs in Ruby?

But they are not **_first class_**:

```ruby
              drinks.map(gulp!) # nope


              drinks.map { |d| d.gulp! } # yep
```

^ Can't pass them around directly. There are weird tricks, like wrapping in
a Proc, but methods are basically not first class objects. Unlike
almost everything else in Ruby is.

^ So what can HOFs help with?

---

## Currying

^ Supplying less than the required number of args to a method
^ Which returns another method, that only requires the remaining args

---

## Currying

```clojure
                     (* 5 2) ; 10
```

---

## Currying

```clojure
                     (* 5 2) ; 10

                     (partial * 5)
                       ; #<core$partial$fn__4228 ...>
```

---

## Currying

Clojure's map function:

```clojure
                  (map fn collection)
```

---

## Currying

```clojure
                   (map (fn [n] * 5 n)
                        [1 2 3 4 5])

                     ; (5 10 15 20 25)
```

---

## Currying

```clojure
                   (map (partial * 5)
                        [1 2 3 4 5])

                     ; (5 10 15 20 25)
```

^ Leads to very reusable functions

---

## Currying Ruby?

```ruby
              mult = lambda { |a,b| a * b }
                # => #<Proc ...>

              times_five = mult.curry[5]
                # => #<Proc ...>
```

^ We can indeed curry lamdas (not methods, mind you)

---

## Currying Ruby?

```ruby
                times_five[10]
                  # => 50

                [1,2,3,4,5].map(&times_five)
                  # => [5, 10, 15, 20, 25]
```

^ But, mind-bending. Hence you don't see it IRL.

---

## Composition

```ruby
                def present?(word)
                  ! blank?(word)
                end

                words.select { |w| present?(w) }
```

---

## Composition

`select` => `filter`
`filter fn collection`

---

## Composition

```clojure
              (defn present? [str]
                (not (blank? str)))

              (filter present? words)
```

^ Example: filtering (select) non-blank words

---

## Composition

```clojure
              (filter #(not (blank? %1))
                      words)
```

---

## Composition

```clojure
              (filter (comp not blank?)
                      words)
```

---

## HOFs in real life

Logger

---

## HOFs

Ring middleware example

---

# [fit] Concurrency

---

## Higher level abstractions

* Elixir: actors/processes & OTP
* Clojure: atoms/agents/refs & STM
* Go: channels and goroutines (`core.async` in Clojure)

---

## Deeper into Concurrency and Ruby...

RuLu: http://v.gd/X0A1HQ

RubyConf AU: http://v.gd/XYFA1b

^ This in itself is a vast topic. I have presented about this before.
Today, I will cover just one aspect of this. If you want more, please
watch one one of my videos.

---

> I would remove the thread and add actors or some other more advanced
> concurrency features
-- Matz

---

## in Ruby: Celluloid

```ruby
                   class Player
                     include Celluloid

                     def serve; end
                   end

                   djoker = Player.new
                   djoker.async.serve

                   Player.supervise_as(:djoker, "Djokovic")
                   Celluloid::Actor[:djoker].async.serve
```

---

## Elixir/Erlang Processes

Processes are _very very_ light-weight

^Show how light they are.
100, 10_000, 100_0000 processes
Then 1000_000 with +P

---

## Elixir/Erlang Processes

Processes are _very very_ light-weight

fault-tolerance: **let it crash**

^ Riak, WhatsApp

---

## Elixir/Erlang Processes

Processes are _very very_ light-weight

fault-tolerance: **let it crash**

OTP framework + Elixir's dynamic nature

---

## Elixir/Erlang Processes

Processes are _very very_ light-weight

fault-tolerance: **let it crash**

OTP framework + Elixir's dynamic nature

Distributed

^ DCell: Over 0mq
