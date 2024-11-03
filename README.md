# laplc - Laplace Language Compiler
The Laplace Programming Language, also known as **Laplace**, is a educational toy pure functional programming language inspired by Haskell. Developed as part of a compilers course for my Computer Science Bachaelors Degree, this language serves as a hands-on tool for understanding the principles of language design and compiler construction. The name "Laplace" pays homage to the mathematician Pierre-Simon Laplace and draws subtle inspiration from the power of Haskell, aiming to bring similar functional features in a simplified form.

Laplace provides strict evaluation, strong static typing, and a clean syntax focused on readability and functional purity. While Laplace includes essential functional programming constructs, it was built as a toy project and is not intended for production use. Its primary goal is to facilitate learning, with implementations for lexical, syntactic, and semantic analysis and a three-address RISC-like code generation system. This makes Laplace a useful educational resource for students and enthusiasts looking to deepen their understanding of compiler fundamentals.

When I wrote Laplace, as a college project, I imagined something consistent and expressive like Haskell but with a simple syntax like Typescript. Fortunately, Microsoft together with a great community of developers is now creating something that can be used professionally like this, the [Lean4 programming language](https://github.com/leanprover/lean4).

## The Laplace Language

Laplace is a pure functional programming language with strict evaluation, strong static typing, and a syntax inspired by TypeScript for readability. It was developed as an educational project to demonstrate fundamental compiler construction concepts. Below are some key features and code examples to illustrate Laplace’s syntax and functionality.

### Basic Syntax and Primitives

Laplace includes four primitive types: `Bool`, `Char`, `Float`, and `Int`. These types have flexible sizes depending on the architecture (e.g., `Float` and `Int` are 64-bit on a 64-bit architecture). Here’s how to declare variables and constants:

```javascript
let x: Int = 42;
const y: Float = 3.14;
const isTrue: Bool = True;
let character: Char = 'A';
```

### Functions

Functions in Laplace are declared with the `function` keyword. The type signature specifies the input types and the return type. Laplace functions are pure, meaning they don’t cause side effects. Here’s a function that adds two numbers:

```javascript
function add: (Int, Int) Int = (a, b) => { a + b };
```

You can also use pattern matching with the `match` keyword for conditional expressions within functions:

```javascript
function isEven: (Int) Bool = (n) => match {
    n % 2 == 0: { True };
    default: { False };
};
```

### Functional Constructs

Laplace supports key functional constructs, including anonymous functions, recursion, and list operations (map, filter, and reduce). Here’s an example of a recursive function to calculate the factorial of a number:

```javascript
function factorial: (Int) Int = (n) => match {
    n <= 1: { 1 };
    default: { n * factorial(n - 1) };
};
```

### Expressions and Operators

Laplace only has expressions—no statements—reflecting its functional nature. You can use mathematical and logical operators for various operations:

```javascript
let result: Float = (x + y) * (z - x) / (z + y);
let comparison: Bool = x > y && y != z;
```

### Example: Checking Legal Age

Here’s a complete example to determine if a person is of legal age (e.g., 18 or older):

```javascript
function legalAge: (Int) Bool = (age) => match {
    age >= 18: { True };
    default: { False };
};

let isLegal: Bool = legalAge(20); // Result: True
```

### Error Handling

Laplace does not throw exceptions; instead, errors are encapsulated, and the compiler provides clear error messages during compilation. For example, attempting to add an `Int` to a `Bool` would result in a type error flagged by the compiler.

### Type Coercion

Laplace enforces strict typing and does not allow implicit type coercion. All type conversions must be explicit, enhancing code safety and readability.

```javascript
let intVal: Int = 42;
let floatVal: Float = float(intVal); // Explicit conversion required
```

### Pure Functional Programming

Laplace is strictly functional, meaning that functions cannot access or modify variables outside their scope, and all functions are free of side effects. This model is ideal for learning functional programming concepts without the complexity of managing mutable state.

### Example: Working with Lists

Although simplified for this educational project, Laplace supports list operations. Here’s an example of mapping a function over a list of integers:

```javascript
let numbers: List[Int] = [1, 2, 3, 4, 5];
let doubledNumbers: List[Int] = map((x) => x * 2, numbers); // [2, 4, 6, 8, 10]
```

Laplace combines the principles of functional purity, strong typing, and simple syntax, making it a concise yet powerful language for understanding functional programming and compiler basics. 

## How to Execute

This project was developed on a Linux environment and can be executed on any computer with Linux as the native or virtualized operating system.

### Prerequisites

Ensure the following packages are installed on your system:

- GCC compiler
- Flex (for lexical analysis)
- Bison (for syntax analysis)
- GNU Make (for automated command execution)

On Ubuntu, you can install these with the following commands:

```bash
sudo apt update && sudo apt upgrade
sudo apt install build-essential
sudo apt install flex bison make -y
```

### Compilation

Navigate to the project's root directory in the terminal and compile the project by running:

```bash
make
```

### Running the Compiler

To execute the compiler interactively, use:

```bash
make run
```

### Testing with a File

To test with a specific input file, you can use the following command (replace the path and filename as necessary):

```bash
./laplc < input/expected_working/functions.lapl
```
