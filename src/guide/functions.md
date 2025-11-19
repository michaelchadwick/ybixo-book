# Using functions and variables

Let's expand our simple program a bit by using a function to determine who is greeted.

```ybixo
// File: examples/chapter_02_functions/hello_world.ob

fn greet(name: String) -> String {
    "Hello, #{name}!"
}

fn main() {
    let greeting = greet("Ybixo")

    print_line(greeting)
}
```

Again, use the Ybixo compiler to run the program and see its ouput:

```
$ obc run hello_world.ob
Hello, Ybixo!
```

This version of the program teaches us a few more things about Ybixo.

## Function parameters

```ybixo
fn greet(name: String)
```

Function parameters are declared with an identifier beginning with a lowercase letter followed by a colon and then a type identifier beginning with an uppercase letter.
In this case, our function `greet` has a single parameter called `name` which must be a `String`.

## Function return values

```ybixo
fn greet(name: String) -> String
```

The type of value a function returns is declared by an arrow followed by a type identifier, written between the parameter list and the function body's curly braces.
In this case, our function returns a `String`.

The value returned by a function is its final expression.
In our case, that's the string `"Hello, #{name}!"`.
If we want, we can also use the `return` keyword to specify the returned value explicitly.
This form can be used to "return early" from a function, even if it's not the last line of the function.
We'll learn in a future chapter why we might want to do so.

```ybixo
return "Hello, #{name}!"
```

The combination of a function's name, parameters, and return type is called its **signature**.

## Variables

```ybixo
let name = "Ybixo"
```

A variable is created by binding a value to an identifier using `let`.
The syntax is the keyword `let` followed by an identifier, an equals sign, and an expression.
A variable name must start with a lowercase letter and should be written in [snake case](https://en.wikipedia.org/wiki/Snake_case), using all lowercase letters and separating "words" with an underscore, e.g. `example_variable_name`.

`let` is actually much more powerful than this simple form, but we'll explore that further in a few chapters.

## String interpolation

```ybixo
"Hello, #{name}!"
```

Strings can contain interpolations, expressions embedded inside literal text, by delimiting the expression with `#{` and `}`.
These expressions must evaluate to a `String`.
