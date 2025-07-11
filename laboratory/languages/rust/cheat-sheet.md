# Rust Cheat Sheet

[docs here](https://doc.rust-lang.org/book/)

## Intro

From the official documentation:
> Rust is a systems programming language that runs blazingly fast, prevents segfaults, and guarantees thread safety. It accomplishes these goals by being memory safe without using garbage collection.

In other words, **Rust** is a systems programming language that focuses on safety, speed, and concurrency, using ownership and borrowing to manage memory without a garbage collector.

## The Basics

### The basic types

| Type name     |  Brief description                                                |  Example                                                |
|:------------- |:-----------------------------------------------------------------:| :------------------------------------------------------:|
| bool          |    A `true` or `false` value                                      | `let is_done: bool = false;`                          |
| i8/i16/i32/i64|    Signed integers of various sizes                               | `let num: i32 = 42;`                                  |
| u8/u16/u32/u64|    Unsigned integers of various sizes                             | `let count: u32 = 100;`                               |
| isize/usize   |    Pointer-sized signed/unsigned integers                         | `let index: usize = 0;`                               |
| f32/f64       |    32-bit and 64-bit floating point numbers                       | `let pi: f64 = 3.14159;`                              |
| char          |    A Unicode scalar value                                         | `let letter: char = 'A';`                             |
| &str          |    String slice (immutable reference to string data)              | `let name: &str = "Rust";`                            |
| String        |    Owned, growable string                                          | `let message: String = String::from("Hello");`        |
| [T; N]        |    Array of N elements of type T                                  | `let arr: [i32; 3] = [1, 2, 3];`                      |
| Vec<T>        |    Growable array (vector)                                        | `let vec: Vec<i32> = vec![1, 2, 3];`                  |
| &[T]          |    Slice (reference to a portion of an array)                     | `let slice: &[i32] = &arr[0..2];`                     |
| (T, U, ...)   |    Tuple with elements of different types                         | `let point: (i32, i32) = (10, 20);`                   |
| Option<T>     |    Optional value that can be Some(T) or None                     | `let maybe: Option<i32> = Some(5);`                   |
| Result<T, E>  |    Result that can be Ok(T) or Err(E)                            | `let result: Result<i32, String> = Ok(42);`           |
| ()            |    Unit type (similar to void)                                    | `fn do_something() -> () { println!("Done"); }`       |

### Variable Declarations

Rust uses `let` for variable declarations and `const` for constants:

```rust
let count = 0; // Immutable by default
let mut counter = 0; // Mutable variable
const MAX_SIZE: usize = 1000; // Constant (must specify type)

// Type inference
let message = "Hello"; // Rust infers &str type
let numbers = vec![1, 2, 3]; // Rust infers Vec<i32>

// Explicit types
let age: u32 = 28;
let name: String = String::from("Miguel");
```

### Functions

```rust
// Function with explicit types
fn add(x: i32, y: i32) -> i32 {
    x + y // No semicolon = return expression
}

// Function returning unit type
fn greet(name: &str) {
    println!("Hello, {}!", name);
}

// Function with optional parameter using Option
fn greet_with_title(name: &str, title: Option<&str>) -> String {
    match title {
        Some(t) => format!("Hello {} {}", t, name),
        None => format!("Hello {}", name),
    }
}

// Function with default parameter (using Option)
fn power(base: f64, exponent: Option<f64>) -> f64 {
    let exp = exponent.unwrap_or(2.0);
    base.powf(exp)
}

// Function with slice parameter
fn sum(numbers: &[i32]) -> i32 {
    numbers.iter().sum()
}
```

### Structs and Implementations

```rust
// Struct definition
struct Person {
    first_name: String,
    last_name: String,
    age: u32,
}

// Struct with lifetime parameter
struct PersonRef<'a> {
    first_name: &'a str,
    last_name: &'a str,
    age: u32,
}

// Implementation block
impl Person {
    // Associated function (like static method)
    fn new(first_name: String, last_name: String, age: u32) -> Person {
        Person {
            first_name,
            last_name,
            age,
        }
    }
    
    // Method (takes &self)
    fn full_name(&self) -> String {
        format!("{} {}", self.first_name, self.last_name)
    }
    
    // Mutable method (takes &mut self)
    fn have_birthday(&mut self) {
        self.age += 1;
    }
    
    // Method that takes ownership (takes self)
    fn into_string(self) -> String {
        format!("{} {} (age {})", self.first_name, self.last_name, self.age)
    }
}
```

### Traits

```rust
// Trait definition
trait Greetable {
    fn greet(&self) -> String;
    
    // Default implementation
    fn greet_loudly(&self) -> String {
        self.greet().to_uppercase()
    }
}

// Implementing trait for struct
impl Greetable for Person {
    fn greet(&self) -> String {
        format!("Hello, I'm {}", self.full_name())
    }
}

// Generic trait implementation
trait Display<T> {
    fn display(&self) -> T;
}

// Trait bounds
fn print_greeting<T: Greetable>(item: &T) {
    println!("{}", item.greet());
}

// Multiple trait bounds
fn print_and_clone<T: Greetable + Clone>(item: &T) -> T {
    println!("{}", item.greet());
    item.clone()
}
```

### Ownership and Borrowing

```rust
// Ownership transfer
fn take_ownership(s: String) {
    println!("{}", s);
} // s goes out of scope and is dropped

// Borrowing (immutable reference)
fn calculate_length(s: &String) -> usize {
    s.len()
} // s goes out of scope but doesn't drop the String

// Mutable borrowing
fn change_string(s: &mut String) {
    s.push_str(", world!");
}

// Example usage
fn ownership_example() {
    let s1 = String::from("hello");
    let len = calculate_length(&s1); // s1 is borrowed
    println!("Length of '{}' is {}", s1, len); // s1 still valid
    
    let mut s2 = String::from("hello");
    change_string(&mut s2);
    println!("{}", s2); // prints "hello, world!"
}
```

### Enums and Pattern Matching

```rust
// Basic enum
enum Direction {
    North,
    South,
    East,
    West,
}

// Enum with data
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(i32, i32, i32),
}

// Pattern matching with match
fn process_message(msg: Message) {
    match msg {
        Message::Quit => println!("Quit"),
        Message::Move { x, y } => println!("Move to ({}, {})", x, y),
        Message::Write(text) => println!("Write: {}", text),
        Message::ChangeColor(r, g, b) => println!("Color: ({}, {}, {})", r, g, b),
    }
}

// Working with Option
fn divide(a: f64, b: f64) -> Option<f64> {
    if b != 0.0 {
        Some(a / b)
    } else {
        None
    }
}

fn handle_division(a: f64, b: f64) {
    match divide(a, b) {
        Some(result) => println!("Result: {}", result),
        None => println!("Cannot divide by zero"),
    }
}
```

### Generics

```rust
// Generic function
fn largest<T: PartialOrd + Copy>(list: &[T]) -> T {
    let mut largest = list[0];
    for &item in list {
        if item > largest {
            largest = item;
        }
    }
    largest
}

// Generic struct
struct Point<T> {
    x: T,
    y: T,
}

impl<T> Point<T> {
    fn new(x: T, y: T) -> Point<T> {
        Point { x, y }
    }
}

// Multiple type parameters
struct Pair<T, U> {
    first: T,
    second: U,
}

// Generic trait
trait Summary<T> {
    fn summarize(&self) -> T;
}

// Generic with lifetime
struct ImportantExcerpt<'a> {
    part: &'a str,
}
```

### Error Handling

```rust
use std::fs::File;
use std::io::ErrorKind;

// Using Result with match
fn open_file() -> Result<File, std::io::Error> {
    let file_result = File::open("hello.txt");
    
    match file_result {
        Ok(file) => Ok(file),
        Err(error) => match error.kind() {
            ErrorKind::NotFound => {
                match File::create("hello.txt") {
                    Ok(created_file) => Ok(created_file),
                    Err(e) => Err(e),
                }
            }
            other_error => Err(error),
        }
    }
}

// Using ? operator for error propagation
fn read_file() -> Result<String, std::io::Error> {
    let mut file = File::open("hello.txt")?;
    let mut contents = String::new();
    file.read_to_string(&mut contents)?;
    Ok(contents)
}

// Custom error types
#[derive(Debug)]
enum MathError {
    DivisionByZero,
    NegativeSquareRoot,
}

fn safe_divide(a: f64, b: f64) -> Result<f64, MathError> {
    if b == 0.0 {
        Err(MathError::DivisionByZero)
    } else {
        Ok(a / b)
    }
}
```

### Collections

```rust
use std::collections::HashMap;

// Vectors
let mut vec = Vec::new();
vec.push(1);
vec.push(2);
vec.push(3);

let vec2 = vec![1, 2, 3, 4, 5];

// Iterating over vector
for item in &vec2 {
    println!("{}", item);
}

// HashMap
let mut scores = HashMap::new();
scores.insert(String::from("Blue"), 10);
scores.insert(String::from("Red"), 50);

// Accessing HashMap values
let team_name = String::from("Blue");
let score = scores.get(&team_name);

match score {
    Some(s) => println!("Score: {}", s),
    None => println!("No score found"),
}

// Iterating over HashMap
for (key, value) in &scores {
    println!("{}: {}", key, value);
}
```

### Modules and Crates

```rust
// Module definition
mod front_of_house {
    pub mod hosting {
        pub fn add_to_waitlist() {}
        fn seat_at_table() {}
    }
    
    mod serving {
        fn take_order() {}
        fn serve_order() {}
        fn take_payment() {}
    }
}

// Using modules
pub fn eat_at_restaurant() {
    // Absolute path
    crate::front_of_house::hosting::add_to_waitlist();
    
    // Relative path
    front_of_house::hosting::add_to_waitlist();
}

// Use statement
use crate::front_of_house::hosting;

pub fn eat_at_restaurant2() {
    hosting::add_to_waitlist();
}

// External crate usage (in Cargo.toml: serde = "1.0")
use serde::{Serialize, Deserialize};

#[derive(Serialize, Deserialize)]
struct Person {
    name: String,
    age: u32,
}
```

### Concurrency

```rust
use std::thread;
use std::sync::mpsc;
use std::time::Duration;

// Basic threading
fn basic_threading() {
    let handle = thread::spawn(|| {
        for i in 1..10 {
            println!("Hi number {} from spawned thread!", i);
            thread::sleep(Duration::from_millis(1));
        }
    });
    
    for i in 1..5 {
        println!("Hi number {} from main thread!", i);
        thread::sleep(Duration::from_millis(1));
    }
    
    handle.join().unwrap();
}

// Message passing
fn message_passing() {
    let (tx, rx) = mpsc::channel();
    
    thread::spawn(move || {
        let val = String::from("hi");
        tx.send(val).unwrap();
    });
    
    let received = rx.recv().unwrap();
    println!("Got: {}", received);
}

// Shared state with Mutex
use std::sync::{Arc, Mutex};

fn shared_state() {
    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];
    
    for _ in 0..10 {
        let counter = Arc::clone(&counter);
        let handle = thread::spawn(move || {
            let mut num = counter.lock().unwrap();
            *num += 1;
        });
        handles.push(handle);
    }
    
    for handle in handles {
        handle.join().unwrap();
    }
    
    println!("Result: {}", *counter.lock().unwrap());
}
```