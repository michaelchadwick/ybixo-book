# Oxiby compared to Rust and Ruby

Oxiby is very similar to Rust, but produces Ruby source code rather than native code.
Why might you use Oxiby over Rust or Ruby?

Since Oxiby is an experimental language in early development, if you're writing a program for production deployment, the answer is that _you shouldn't_.
But if you're interested in learning and experimenting, there are a few fundamental trade-offs.

## Compared to Rust

Oxiby's syntax and feature set are quite similar to Rust.
The main difference is that Oxiby is not a systems programming language.
That means it does not offer the programmer explicit features for memory management and other low-level operations.
It's intended for high-level programs that would otherwise have been suitable for a language like Ruby or Python.

Oxiby also lacks one of Rust's distinguishing features, the tracking of reference lifetimes.
Since Oxiby is executed by the Ruby interpreter, data is generally stored on the heap and garbage collected.
Oxiby is also not strict about the mutability of values.
This means that Oxiby programs are not protected from data races, whereas in Rust they are prevented statically.

If you like Rust's type system and feature set, but aren't writing a program that needs manual memory management or strict enforcement over lifetimes, Oxiby should be easier to write.

Finally, because Oxiby produces Ruby source code rather than native code, Rust programs will be signficantly more performant.

## Compared to Ruby

Oxiby doesn't have much superficial similarity to Ruby.
The main difference between the two is that Oxiby is statically typed.
This means that Oxiby will statically eliminate many classes of errors that happen at runtime in Ruby programs.

On the flip side, Oxiby programs are greatly constrained in terms of the dynamic behavior that is possible in Ruby.
A primary is example is meta-programming.
Oxiby does not have a macro system, so there is no equivalent of Ruby's meta-programming facilities, such as dynamic method definition and execution.

Although Oxiby produces Ruby source code, many of the features of Ruby are not exposed by Oxiby, such as implicit blocks.
If you want to write a program that interfaces with existing Ruby libraries, it will not be possible in Oxiby.

Oxiby is a good fit if you're writing a program with no Ruby dependencies and you want more protection from runtime errors than Ruby offers.
