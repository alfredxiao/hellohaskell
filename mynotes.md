# Concepts
## pure function
* takes input arguments, return a value
* no side-effects: reading/writing to io/sockets, no reading/writing global variables, no throwing or catching exception
* given particular input, it will always generate the exact same output.
## classes of functional languages
* impure: Scheme, OCaml. where you are allowed to write functions having side effects
* pure: Haskell. where you are not allowed to write side-effecting functions DIRECTLY.

# Benefits of Monads
* Solve side-effecting problem without destroying the purity of the language.
* Solve similar non-side-effecting problems as well

# Notion of computation
Pure functions are the simplest notion of computation. Yet there are others:

## I/O: file, terminal, network
Any function in C or Java can do I/O
## raise exceptions
* In C, there is no language support for exception. The contract is w.e rely on return value to signify an error condition. Or tricky stuff like setjmp/longjmp
* In Java, language support.
## read/write global state
* Beautifully supported in C/Java. Even though in Java, you need to rely a class to hold global state.
### DbC, or Design by Contract
* Eiffel
* precondition, postcondition, invariants. examples ?
* UML, OCL: example: ?
* Property based testing: examples?
* assertion in c++/java/clojure?
## may produce multiple results at the same time
* not referring to a C struct or Java object
* intent is to convey extra information in addition/parallel to output value. e.g. convey error information
### C
Use of struct, make a field like `status` or `resultCode`. But are you going to apply this to all ouput structs?
### Java
Use of Object, but same as above. Fortunately, we have exception to convey error information.
### Go
Quote from Golang FAQ: We believe that coupling exceptions to a control structure, as in the try-catch-finally idiom, results in convoluted code. It also tends to encourage programmers to label too many ordinary errors, such as failing to open a file, as exceptional.
So, Go provides multi-value returns.


# Unavoidability
* Benjamin Franklin : there are two things in life that are unavoidable – death and taxes.
* Programmers: IO and exceptions are unavoidable
We know that the above situations are unavoidable, but the key is, how to do these non-pure things in a better way?


# Basics
## function type
* f :: a -> b
* f :: Int -> Int
* f x = 2 * x
## currying
* f x y :: Int -> Int -> Int
* read as (left): (f x) y 
* read as (right): Int -> (Int -> Int)
* things of this like: Pixels, eating things one by one, but each time it eats one, it changes itself slightly (turn into another function)
* the other thing is: when thinging about function application, one argument at a time
## infix
* `2 * x` is same is `(*) 2 x`
## function application operator $
* `f $ 2` means `($) f 2` which apply/calls function f with argument 2
## function composition
`h = g.f` means `h x = g (f x)`
* unix pipeline and the unix philosophy
* monolithic and micro services
## lambda expression
\x y -> x + y

# More concepts
## Referential Transparency
A computation is referentially transparent whenever it can be replaced by its result (as an expressible value) in the source text without affecting the meaning of the program.
## One Logic One Place
Good design dictates that a distinct block of code should do just one thing, and that it should be clear what that one thing is.
## What do we mean by 'side effects'?
## is Monad a functional idiom?

