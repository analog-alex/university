# Kotlin Cheat Sheet

[docs here](https://kotlinlang.org/docs/reference/)

## Intro

From wiki:
> Kotlin is a cross-platform, statically typed, general-purpose programming language with type inference. Kotlin is designed to interoperate fully with Java, and the JVM version of its standard library depends on the Java Class Library, but type inference allows its syntax to be more concise. Kotlin mainly targets the JVM, but also compiles to JavaScript or native code (via LLVM). Language development costs are borne by JetBrains, while the Kotlin Foundation protects the Kotlin trademark.

## The Basics

### The basic types

*this part is easy*😅

| Kotlin type   | Java relative |  Brief description    |
| ------------- |:-------------:|:-------------------------------:| 
| Byte          | byte          |    8bits _[-127, 128]_          |
| Short         | short         |    16bits _[-32768, 32768]_     |
| Int           | int           |    32bits _[-2^31, 2^31]_       |
| Long          | long          |    64bits _[-2^63, 2^63]_       |
| Float         | float         |    32bits                       |
| Double        | double        |    64bits                       |
| Char          | char          |    represents a single character (e.g. '1' or 'a')    |
| String        | String        |     an immutable String of characters   |
| Boolean       | boolean       |    truth value i.e. *true* or *false*   |
| Array<T>      | T[]           |    a memory-contiguous collection of types    |


### Declarations

In Kotlin, declaring simple types is done in the following fashion:
[val|var] [name] : [type]

Where *val* indicates a immutable value and *var* a variable (_as the name indicates_) one. 

```kotlin
val one: Integer = 1
val one = 1 // type can be omitted when it can be inferred from the context. 

var two = 2
two = two + 2

one = one + 1 //  will not compile
```

Note that in all cases the terminating semi-colon (;) can be omitted in Kotlin.

Other variations include **const val** indicating a constant value present at compile time (i.e. cannot be attibuted by a function) and **lateinit var** for variables initialized by dependency injections or in other _setup_ methods.

---

Functions follow a similar pattern, but with the reserved _keyword_ *fun*
*fun* [name] ([*args]+) : [return type]

```kotlin
fun sucessor(number: Int): Int {
  //... function body
  return number + 1
}

// one liner
fun name() = "Miguel"

//  extensions
fun String.isEmptyOrNull() = this == null || this.isEmpty()
"Miguel".isEmptyOrNull()

// infix
infix fun Int.add(x: Int): Int = this + x
1 shl 2 

// inline
/* 
   inline functions insert the function's code at every call point
   instead of formally calling a function (moving the insteruction pointer, etc...)
*/
inline fun ....

```

### String Interpolation

```kotlin
val name = "Miguel"
val age = 28

val interpolation = "My name is $name and I'm $age years old. I'm ${ 30 - age } from my thirties."
```

### Flow control

Here we find our usual flow control expressions like **if** and others not so usual like **when** that replaces the _switch_ operator.

```kotlin
// Traditional usage 
var max = a 
if (a < b) {
  max = b
  println(max)
}  

// As expression 
val max = if (a > b) a else b

// 'when' example
when (x) {
    1 -> print("x == 1")
    2 -> print("x == 2")
    else -> { // Note the block
        print("x is neither 1 nor 2")
    }
}
```

### Loops and Ranges

Loops in Kotlin are pretty standard.
Note the *println* function that writes to standard output.

```kotlin

val names = listOf("Miguel", "Rafael", "Gabriel")
for(name in names) { 
  println(name)
}

var x = 0
while (x < 10) {
    println(x)
    x++ 
}

```

One can use streams just like in Java. They are specially useful when collections are involved.

```kotlin

val addOneAndCountEvenNumbers: Int = (1..100).map { it + 1 }.filter { it % 2 == 0 }.size
val sumOfNumbersFromOneToOneHundred = (1..100).reduce { a, i -> a + 1 }
```

### Collections

There is quite a practical distinction explicit in Kotlin collections, specially _vis-a-vis_ Java / C# standards between *mutable* and *immutable* collections. To wit, with an immutable collection, after it is initialised, it is impossible to add any more elements.

Below we run through some examples:

```kotlin

val names = listOf("Miguel", "Gabriel", "Rafael") // immutable
val numbers: List<Int> = listOf<Int>()

val miguel: String = names[0]

val names = mutableListOf("Miguel", "Gabriel", "Rafael") // mutable
names.add("Manuel")

val set = setOf(1, 1, 2, 3)
val map = hashMapOf(1 to "Pizza", 2 to "Hamburger")

val pizza: String = map[1]

val otherMap = names.associateWith { it.length } // {Miguel=6, Gabriel=7, Rafael=6}

```

### Classes and Inheritance

Kotlin removes some boilerplate when it comes to class declarations. Data classes allow one to quickly build container classes without having to specify getters & setters, hashCodes, equals and toString functions because those are automatically generated by the compiler. Public, Protected, and Private keywords are reserved to represent access levels to class properties and methods. 

One thing to note in relation to inheritance is that in Kotlin all classes and class methods are non-virtual, that is *final* by default unlike in, say, Java. So the key word **open** must be applied to those classes AND to class methods one wishes to be made overridable.

Below we run by some basic patterns:

```kotlin

class Person(val name: String, var age: Int)

data class User(val username: String, val password: String)
//... Getters & Setters, HashCode(), Equals(), toString() and Copy() automatically generated

class Human(val name: String) {

  // redundant getter and setter
  val age: Int = 0
    get() = field
    set(value) {
      field = value
    } 
    
 val isUnderage: Boolean
    get() = this.age <= 18
}

open class Animal
class Dog : Animal()
class Cat: Animal()

// more polymorphism
open class Car (protected val speed: Int) {
    open fun race(): String {
        return "This car goes at $speed kph"
    }
}

class Ferrari : Car(speed = 100) {
    override fun race(): String {
        return "This Ferrari goes at $speed kph"
    }
}

class Ford : Car(speed = 50) {
    override fun race(): String {
        return "This Ford goes at $speed kph"
    }
}

val cars = mutableListOf<Car>()
cars.add(Ferrari())
cars.add(Ford())

cars.forEach { println(it.race()) }
// This Ferrari goes at 100 kph
// This Ford goes at 50 kph
```

Static members and function are not really a thing in Koltin. For singletons the construct **object** is prefered.

```kotlin
object Myself {
    fun me() = "Miguel"
}
```

While for static like beahviour a companion object can be attached to a class. 

```kotlin
class Person {
    companion object {
        fun me() = "Miguel"
    }
}
```

Enums are present as well.

```kotlin
enum class Direction {
    NORTH, SOUTH, EAST, WEST 
}
println(Direction.NORTH) // => NORTH
println(Direction.EAST == Direction.WEST) // => false
println(Direction.SOUTH.ordinal) // => 1
Direction.values().forEach(::println) // => NORTHSOUTHEASTWESTSOUTH
println(Direction.valueOf("SOUTH")) // => SOUTH
```

### Nullable types

Any type can be made to be nullable by adding a question mark to its type declaration e.g. Int?, String?, ...
Null checks are chainable and Kotlin scope function come in handy to work with them! 

```kotlin
val name: String = null // will not compile
val name: String? = null

val otherName: String? = "A name"

if(otherName) {
  // other name was cast from String? to String
}

// null checks are chainable
class Person (val name: String)
val person = // ....
val name = person?.name

person?.let {
  person.name = "A name"
}

val name: person?.name ?: "Person is null"

// scope functions clear up the code
person?.name?.takeIf {
  it == "A name"
}.let {
  println("Found!)
}
```

### Scope Functions

Scope function allow the creations of a series of expressions that take a given object as context. The functions are let, run, with, apply, and also.
To exemplify:

```kotlin
// let
Person("Alice", 20, "Amsterdam").let {
    println(it)
    it.moveTo("London")
    it.incrementAge()
    println(it)
}

// run
val numbers = mutableListOf("one", "two", "three")
val countEndsWithE = numbers.run { 
    add("four")
    add("five")
    count { it.endsWith("e") }
}

// with
val firstAndLast = with(numbers) {
    "The first element is ${first()}," +
    " the last element is ${last()}"
}

// apply
val adam = Person("Adam").apply { 
    age = 20                       // same as this.age = 20 or adam.age = 20
    city = "London"
}

// also
fun getRandomInt(): Int {
    return Random.nextInt(100).also {
        writeToLog("getRandomInt() generated value $it")
    }
}

```

### Type alias

Rename a type to avoid namespace collisions or to ease readability.

```kotlin
typealias PersonSet = Set<Person>
```

### Delegation

Two cool features that are available out of the box as syntatic sugar involving delegation is the **lazy** delegate and the delegate by **map**.

In the **lazy** case hard hitting code can be made to run only on the first access to the variable.
```kotlin
val value: String by lazy {
    val response = HttpService.get("/five/minute/call")
    response.toString()
}
```

As for the **map** delegate, it deserializes the map _values_ to normal properties with the same name as the _key_.
```kotlin
class Club (val map: Map<String, Any>) {
  val name: String  by map
  val trophies: Int by map
}

Club(mapOf(
    "name" to "benfica",
    "trophies" to Int.MAX_SIZE
  )
)
```

