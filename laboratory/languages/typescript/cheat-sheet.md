# TypeScript Cheat Sheet

[docs here](https://www.typescriptlang.org/docs/handbook/intro.html)

## Intro

From wiki:
> TypeScript is an open-source programming language developed and maintained by Microsoft. It is a strict syntactical superset of JavaScript and adds optional static typing to the language. TypeScript is designed for development of large applications and transcompiles to JavaScript. As TypeScript is a superset of JavaScript, existing JavaScript programs are also valid TypeScript programs. 

In other words, **Typescript** is a super-set of **Javascript**, adding `types` and transpile-time type-checking as well as some extra syntax and sugar.

## The Basics

### The basic types

| Type name     |  Brief description                                                |  Example                                                |
|:------------- |:-----------------------------------------------------------------:| :------------------------------------------------------:|
| boolean       |    A `true` or `false` value                                      | `let isDone: boolean = false;`                         |
| number        |    An integer or decimal (float) type number                      | `let decimal: number = 6; let hex: number = 0xf00d;`   |
| string        |    A series of characters representing text                       | `let color: string = "blue";`                          |
| array         |    A collection of objects                                        | `let list: number[] = [1, 2, 3];`                      |
| tuple         |    An array of fixed number of objects with arbitrary types       | `let x: [string, number] = ["hello", 10];`             |
| enum          |    Friendly names for a set of predetermined numeric values       | `enum Color {Red, Green, Blue}`                         |
| unknown       |    Not known at runtime, a wildcard type                          | `let notSure: unknown = 4;`                            |
| any           |    Any possible type                                              | `let looselyTyped: any = 4;`                           |
| void          |    Absence of value                                               | `function warnUser(): void { console.log("Warning!"); }` |
| null          |    A reference that points of nothing.                            | `let n: null = null;`                                   |
| undefined     |    An undefined value (not initialized)                           | `let u: undefined = undefined;`                         |
| never         |    The return type of a function that never returns 😅            | `function error(): never { throw new Error(); }`       |
| Object        |    A non primitive type                                           | `let obj: object = {};`                                 |

### Variable Declarations

TypeScript uses `let`, `const`, and `var` for variable declarations:

```typescript
let count: number = 0;
const name: string = "Miguel";
var age: number = 28;

// Type inference
let message = "Hello"; // TypeScript infers string type
```

### Functions

```typescript
// Function declaration with types
function add(x: number, y: number): number {
    return x + y;
}

// Arrow function
const multiply = (x: number, y: number): number => x * y;

// Optional parameters
function greet(name: string, title?: string): string {
    return title ? `Hello ${title} ${name}` : `Hello ${name}`;
}

// Default parameters
function power(base: number, exponent: number = 2): number {
    return Math.pow(base, exponent);
}

// Rest parameters
function sum(...numbers: number[]): number {
    return numbers.reduce((total, num) => total + num, 0);
}
```

### Interfaces

```typescript
interface Person {
    firstName: string;
    lastName: string;
    age?: number; // Optional property
    readonly id: number; // Read-only property
}

interface Greetable {
    greet(phrase: string): void;
}

class Student implements Person, Greetable {
    firstName: string;
    lastName: string;
    readonly id: number;
    
    constructor(firstName: string, lastName: string, id: number) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.id = id;
    }
    
    greet(phrase: string) {
        console.log(`${phrase} ${this.firstName}`);
    }
}
```

### Classes

```typescript
class Animal {
    private name: string;
    protected species: string;
    public age: number;
    
    constructor(name: string, species: string, age: number) {
        this.name = name;
        this.species = species;
        this.age = age;
    }
    
    public move(distance: number): void {
        console.log(`${this.name} moved ${distance} meters`);
    }
    
    protected makeSound(): void {
        console.log("Some sound");
    }
}

class Dog extends Animal {
    constructor(name: string, age: number) {
        super(name, "Canine", age);
    }
    
    bark(): void {
        console.log("Woof! Woof!");
        this.makeSound(); // Can access protected method
    }
}
```

### Generics

```typescript
// Generic function
function identity<T>(arg: T): T {
    return arg;
}

let output = identity<string>("myString");
let output2 = identity("myString"); // Type inference

// Generic interface
interface GenericIdentityFn<T> {
    (arg: T): T;
}

// Generic class
class GenericNumber<T> {
    zeroValue: T;
    add: (x: T, y: T) => T;
}

// Generic constraints
interface Lengthwise {
    length: number;
}

function loggingIdentity<T extends Lengthwise>(arg: T): T {
    console.log(arg.length);
    return arg;
}
```

### Union Types and Type Guards

```typescript
// Union types
type StringOrNumber = string | number;

function padLeft(value: string, padding: StringOrNumber) {
    if (typeof padding === "number") {
        return Array(padding + 1).join(" ") + value;
    }
    if (typeof padding === "string") {
        return padding + value;
    }
    throw new Error(`Expected string or number, got '${padding}'.`);
}

// Type aliases
type Point = {
    x: number;
    y: number;
};

type ID = string | number;
```

### Advanced Types

```typescript
// Intersection types
interface ErrorHandling {
    success: boolean;
    error?: { message: string };
}

interface ArtworksData {
    artworks: { title: string }[];
}

type ArtworksResponse = ArtworksData & ErrorHandling;

// Conditional types
type ApiResponse<T> = T extends string ? string : number;

// Mapped types
type Readonly<T> = {
    readonly [P in keyof T]: T[P];
}

type Partial<T> = {
    [P in keyof T]?: T[P];
}
```

### Modules and Namespaces

```typescript
// Module export/import
export interface StringValidator {
    isAcceptable(s: string): boolean;
}

export const numberRegexp = /^[0-9]+$/;

export class ZipCodeValidator implements StringValidator {
    isAcceptable(s: string) {
        return s.length === 5 && numberRegexp.test(s);
    }
}

// Import
import { StringValidator, ZipCodeValidator } from "./validators";

// Namespace
namespace Validation {
    export interface StringValidator {
        isAcceptable(s: string): boolean;
    }
    
    export class LettersOnlyValidator implements StringValidator {
        isAcceptable(s: string) {
            return /^[A-Za-z]+$/.test(s);
        }
    }
}
```

### Utility Types

```typescript
// Partial<T> - makes all properties optional
interface Todo {
    title: string;
    description: string;
}

function updateTodo(todo: Todo, fieldsToUpdate: Partial<Todo>) {
    return { ...todo, ...fieldsToUpdate };
}

// Required<T> - makes all properties required
type RequiredTodo = Required<Partial<Todo>>;

// Pick<T, K> - picks specific properties
type TodoPreview = Pick<Todo, "title">;

// Omit<T, K> - omits specific properties
type TodoInfo = Omit<Todo, "title">;

// Record<K, T> - creates an object type with keys K and values T
type Page = "home" | "about" | "contact";
type PageInfo = Record<Page, {title: string; url: string}>;
```

### Decorators

```typescript
// Class decorator
function sealed(constructor: Function) {
    Object.seal(constructor);
    Object.seal(constructor.prototype);
}

@sealed
class Greeter {
    greeting: string;
    constructor(message: string) {
        this.greeting = message;
    }
}

// Method decorator
function enumerable(value: boolean) {
    return function (target: any, propertyKey: string, descriptor: PropertyDescriptor) {
        descriptor.enumerable = value;
    };
}

class Example {
    @enumerable(false)
    greet() {
        return "hello";
    }
}
```
