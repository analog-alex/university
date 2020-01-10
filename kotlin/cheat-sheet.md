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
