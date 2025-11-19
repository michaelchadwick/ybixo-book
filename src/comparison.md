# Ybixo compared to Rust and Ruby

Ybixo is very similar to Rust, but produces Ruby source code rather than native code.
Why might you use Ybixo over Rust or Ruby?

Since Ybixo is an experimental language in early development, if you're writing a program for production deployment, the answer is that _you shouldn't_.
But if you're interested in learning and experimenting, there are a few fundamental trade-offs.

## Compared to Rust

Ybixo's syntax and feature set are quite similar to Rust.
The biggest difference is that Ybixo is not a systems programming language.
That means it does not offer the programmer explicit features for memory management and other low-level operations.
It's intended for high-level programs that would otherwise have been suitable for a language like Ruby or Python.

Ybixo also lacks one of Rust's distinguishing features, the tracking of reference lifetimes.
Since Ybixo is executed by the Ruby interpreter, data is generally stored on the heap and garbage collected.

Closely related to reference tracking is another key feature of Rust's type system: [move semantics](https://en.wikipedia.org/wiki/Substructural_type_system#Affine_type_systems), which allows "ownership" of a value to be moved from one place to another, preventing its use at the original place.
Ybixo has no equivalent to this behavior.

Ybixo is also not strict about the mutability of values.
This means that Ybixo programs are not protected from data races, whereas in Rust they are prevented statically.

Finally, because Ybixo produces Ruby source code rather than native code, Rust programs will be signficantly more performant.

If you like Rust's type system and feature set, but aren't writing a program that needs manual memory management, strict protection of immutable data, or maximal performance, Ybixo should be easier to use.

Specific examples of some of the differences between the two languages follow.

### Memory allocation

Rust allows you to choose whether data is on the stack or on the heap:

```rust
fn main() {
    let on_the_stack = 1u8;
    let on_the_heap = Box::new(1u8);
}
```

Ybixo has no such control.
All data is allocated on the heap.
This makes Ybixo easier to use because you don't need to think about the distinction and all types can be dynamically sized.
However, this comes with a performance trade-off, since the bookkeeping required to manage heap memory has a cost.

### References and mutability

The following Rust program will not compile because the function `change_container_contents` attempts to mutate a value through an immutable reference:

```rust
struct Container(String);

fn change_container_contents(container: &Container) {
    container.0 = String::from("Hello, mutability");
}

fn main() {
    let container = Container(String::from("Hello, world"));
    change_container_contents(&container);
    println!("{}", container.0);
}
```

In Ybixo, there are neither explicit references nor is there a way to mark a name as immutable, so a working equivalent would be:

```ybixo
struct Container(String);

fn change_container_contents(container: Container) {
    container.0 = "Hello, mutability"
}

fn main() {
    let container = Container("Hello, world")
    change_container_contents(container)
    print_line(container.0)
}
```

This means that Ybixo is easier to write, because you don't need to keep track of references and mutability.
The trade-off is that you can introduce bugs by mutating data that should be immutable.

### Move semantics

In Rust, moving a value (passing it by value rather than by reference) prevents access to it at its original location:

```rust
fn move_data(data: String) {}

fn main() {
    let data = String::from("Hello, move semantics");
    move_data(data);
    println!("{data}"); // Error: borrow of moved value: `data`
}
```

Ybixo's type system does not include this behavior, so the equivalent program will run:

```ybixo
fn move_data(data: String) {}

fn main() {
    let data = "Hello, move semantics"
    move_data(data)
    print_line(data)
}
```

Move semantics are an important part of the system that provides Rust programs memory safety.
Since Ybixo is executed by the Ruby interpreter, which uses garbage collection, programs are still memory safe, even without move semantics.

## Compared to Ruby

Ybixo doesn't have much superficial similarity to Ruby.
The biggest difference between the two is that Ybixo is statically typed.
This means that Ybixo will statically eliminate many classes of errors that happen at runtime in Ruby programs.

On the flip side, Ybixo programs are greatly constrained in terms of the dynamic behavior that is possible in Ruby.
A primary is example is metaprogramming.
Ybixo does not have a macro system, so there is no equivalent of Ruby's metaprogramming facilities, such as dynamic method definition and execution.

Ruby does not support file-scoped code.
A Ruby program written across multiple files will simply "require" one file from another, and the code in both files are executed in the same global, mutable namespace.
Ybixo has a module system in which files are isolated from each other and items from other files are brought into scope with explicit imports.
This improves local reasoning and makes name conflicts explicit.

Ruby uses exception-based error handling, while Ybixo uses value-based error handling.
This makes it easier to get a quick prototype working in Ruby, but it will be susceptible to runtime errors that would not be possible in Ybixo.
Additionally, it is easier to reason about failure cases in Ybixo.

Ruby optimizes its syntax for calling functions at the expense of referencing functions.
This allows functions to be called without parentheses, but makes it more awkward to assign functions to variables that can be passed as function arguments.
Ybixo requires parentheses for calling functions, so a function can be easily treated as a first-class value by omitting the parentheses.

Although Ybixo produces Ruby source code, many of the features of Ruby are not exposed by Ybixo, such as its multiple types of anonymous functions.
If you want to write a program that interfaces with existing Ruby libraries, it will not be possible in Ybixo.

Ybixo is a good fit if you're writing a program with no Ruby dependencies and you want more protection from runtime errors than Ruby offers.

Specific examples of some of the differences between the two languages follow.

### Dynamic typing

Trivial type errors will cause Ruby programs to crash at runtime:

```ruby
string = 3.14159

# At runtime, will raise:
# NoMethodError: undefined method 'upcase' for an instance of Float
string.upcase
```

The equivalent Ybixo program would fail to compile due to the type mismatch in second line.

### Metaprogramming

Ruby can define methods at runtime with metaprogramming techniques:

```ruby
["apples", "bananas", "carrots"].each do |fruit|
  define_method(fruit) do
    "I love to eat #{fruit}!"
  end
end

puts apples  # Prints "I love to eat apples!"
puts bananas # Prints "I love to eat bananas!"
puts carrots # Prints "I love to eat carrots!"
```

Ybixo has no equivalent of this behavior.
Instead, an Ybixo program would be less clever and simply define one function with a parameter for the fruit:

```ybixo
fn lovely_fruit(fruit: String) -> String {
    "I love to eat #{fruit}!"
}

fn main() {
    print_line(lovely_fruit("apples"))
    print_line(lovely_fruit("bananas"))
    print_line(lovely_fruit("carrots"))
}
```

The difference might seem unimportant in this trivial example, but metaprogramming can be used to signficantly reduce the amount of source code required in a program.
Ybixo is more straightforward at the expense of being more verbose.

### Modules

In Ruby, requiring code in another file can mutate the global namespace in any way:

```ruby
class Car
  def drive
    "Driving the car!"
  end
end

require "truck"

Car.new.drive
Truck.new.drive
```

In the above program, there is no way to tell from this file's source code what effect requiring "truck" had.
The lines below the `require` suggest that it defined a class called `Truck`, but this is simply assumed, and will crash at runtime if the assumption is wrong.
Furthermore, the "truck" file could have defined its own `Car` class which would overwrite the local one due to the `require` coming after the local definition.
Because of this, it's not possible to know from looking at this source code what `Car.new.drive` will actually do at runtime.

In Ybixo, the only side effect importing from a module has is that, if it has a `main` function, it will be run automatically, which is useful for initialization code.
However, any impact on the local file's namespace is explicitly controlled with named imports.
The equivalent Ybixo program would be:

```ybixo
struct Car {
    fn drive(self) -> String {
        "Driving the car!"
    }
}

use truck Truck

fn main() {
    let car = Car {}
    car.drive()

    let truck = Truck {}
    truck.drive()
}
```

In this program, code inside the "truck" module cannot modify the behavior of `Car`, and regardless of what items it defines, only the explicitly imported `Truck` type is exposed to the local module.

### Error handling

Ruby programs propagate and handle errors with exceptions.
Any code can raise an exception, which will propagate up the stack and crash the program at runtime, unless it is explicitly rescued and handled by code higher up the stack.

```ruby
def might_crash
  will_crash
rescue StandardError
end

def will_crash
  raise StandardError
end

def main
  # We cannot tell from looking at the signature of `might_crash` if this is safe
  might_crash
end
```

Because any function can raise an exception of any type, you cannot look at a function's signature to know all of the possible failure cases that should be handled.

Ybixo requires that fallible functions indicate their fallibility as part of their signature, making it very clear to callers what the failure cases are and how to handle them:

```ybixo
fn might_error() -> Result<(), String> {
    will_error()
}

fn will_error() -> Result<(), String> {
    Err("something bad happened")
}

fn main () {
    match might_error() {
        Ok(_) -> print_line("It succeeded"),
        Err(error) -> print_line("It failed: #{error}"),
    }
}
```

### Functions as first-class values

In Ruby, writing the name of a function calls it.
Referencing a function as a value requires extra ceremony:

```ruby
greet # Calls the greet method
method(:greet) # Creates a first-class "method object" from greet
```

The equivalent Ybixo is more succinct:

```ybixo
greet() // Calls the greet function
greet // References the greet function
```

### Anonymous functions

Ruby has three forms of anonymous functions: implicit blocks, procs, and lambdas.

```ruby
class MyArray
  def initialize(array)
    @array = array
  end

  def each
    for element in @array
      yield element
    end
  end
end

my_array = MyArray.new([1, 2, 3])
my_array.each do |element|
  puts element
end
```

In this example, the last expression calls `MyArray#each` with an implicit block not mentioned in the signature of `MyArray#each` and the `yield` keyword is used to execute this implict block with a parameter.
Ruby can optionally make this pattern explict by "capturing" the block with the `&` operator, which converts the implicit block to a proc object and changes the way it is executed:

```ruby
def each(&block)
  for element in @array
    block.call(element)
  end
end
```

The form of the anonymous function can also be changed at the call site.
The caller can create a "proc" and pass it as an explicit argument.

```ruby
my_array = MyArray.new([1, 2, 3])
my_proc = Proc.new do |element|
  puts element
end
my_array.each(my_proc)
```

In either form of `MyArray#each` shown above, passing an explicit proc will cause an `ArgumentError` at runtime.
Instead, `MyArray#each` would have to be defined in yet another form, with a single parameter which gives no visual indication in the signature that the parameter is callable:

```ruby
def each(block)
  for element in @array
    block.call(element)
  end
end
```

And there is yet another form of anonymous function, the lambda:

```ruby
my_array = MyArray.new([1, 2, 3])
my_lambda = -> (element) do
  puts element
end
my_array.each(my_lambda)
```

In this example, the difference between a proc and a lambda has no impact on its usage with `MyArray#each`.
The difference between the two is that the lambda has stricter behavior with regards to argument arity and control flow keywords.
Using `return` from inside a lambda will return from the lambda, whereas using `return` from inside a proc will return from the function where the proc is called.

In Ybixo, none of this complexity is present.
There is only one form of anonymous function, the closure, and functions must be explicit that they accept them as parameters in their signatures:

```ybixo
struct MyArray<t> {
    array: List<t>,

    fn each(self, f: f) where f: Fn() {
        for element in self.array {
            f(element)
        }
    }
}

fn main() {
    let my_array = MyArray {
        array: [1, 2, 3],
    }

    my_array.each(fn (element) {
        print_line(element)
    })
}
```

In Ybixo, closures behave exactly like functions with regard to control flow keywords, so they have no ability to return early from the function in which they are called.
