# Kotlin Cheat Seet

for Java developers

## Intro

*Kotlin* is a JVM based (but has since slouched beyond the JVM) language that modernizes the syntax and verbosity of the usual statically-typed, object-oriented, "enterprise", _C-like_, Java and C#.

In its JVM form it has full introperability with the Java ecosystem of libraties and frameworks.

It is used widely in Mobile and Back-End development, even recetely becoming Google's primary language for the Android SDK.

## The Basics

### The types

*this part is easy*😅

| Kotlin        | Java          |
| ------------- |:-------------:| 
| Byte          | byte          |
| Short         | short         |
| Int           | int           |
| Long          | long          |
| Float         | float         |
| Double        | double        |
| Char          | char          |
| String        | String        |
| Boolean       | boolean       |
| Array<T>      | T[]           |


### Declarations

In Kotlin, declaring simple types is done in the following fashion:
[val|var] [name] : [type]

Where *val* indicates a immutable value and *var* a variable (_as the name indicates_) one.

Vis-a-vis Java

```java
Integer one = 1
```

```kotlin
val one: Integer = 1
val one = 1 // type can be omitted when it can be infered from the context. 
```

Note that in all cases the terminating semi-colon (;) can be omitted in Kotlin.

Functions follow a similar pattern, but with the reserved _keyword_ *fun*
*fun* [name] ([*args]+) : [return type]

Again, vis-a-vis Java:

```java
Integer successor (Integer number);
```

```kotlin
fun sucessor(number: Int): Int
```

### String Interpolation

```kotlin
val name = "Miguel"
val age = 28

val interpolation = "My name is $name and I'm $age years old. I'm ${ 30 - age } from my thirties."
```

### Loops and Ranges

Loops in Kotlin are pretty standart.
Note the *println* function that writes to standart output.

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



### Nullable types

Any type can be made to be nullable by adding a question mark to its type declaration e.g. Int?, String?, ...

```kotlin
val name: String = null // will not compile
val name: String? = null

val otherName: String? = "A name"

if(otherName) {
  // other name was cast from String? to String
}
```

Null is chainable

```kotlin
class Person (val name: String)

val person = // ....

val name = person?.name

person?.let {
  person.name = "A name"
}
```

Operators on nullable type

```kotlin

val name: person?.name ?: "Person is null"

person?.name?.takeIf {
  it == "A name"
}.let {
  println("Found!)
}

```

