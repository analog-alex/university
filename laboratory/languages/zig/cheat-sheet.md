# Zig Cheat Sheet

[docs here](https://ziglang.org/documentation/master/)

## Intro

From the official documentation:
> Zig is a general-purpose programming language and toolchain for maintaining robust, optimal, and reusable software. It is intended to replace C, while avoiding the pitfalls of C++.

In other words, **Zig** is a systems programming language that aims to be a better C, focusing on simplicity, performance, safety, and clear error handling without hidden control flow.

## The Basics

### The basic types

| Type name     |  Brief description                                                |  Example                                                |
|:------------- |:-----------------------------------------------------------------:| :------------------------------------------------------:|
| bool          |    A `true` or `false` value                                      | `var is_done: bool = false;`                          |
| i8/i16/i32/i64|    Signed integers of various sizes                               | `var num: i32 = 42;`                                  |
| u8/u16/u32/u64|    Unsigned integers of various sizes                             | `var count: u32 = 100;`                               |
| isize/usize   |    Pointer-sized signed/unsigned integers                         | `var index: usize = 0;`                               |
| f32/f64       |    32-bit and 64-bit floating point numbers                       | `var pi: f64 = 3.14159;`                              |
| c_short/c_int |    C-compatible integer types                                      | `var c_num: c_int = 42;`                              |
| u8             |    Often used for byte and character data                         | `var byte: u8 = 65;`                                  |
| []const u8    |    String literal type (slice of bytes)                           | `var name: []const u8 = "Zig";`                       |
| []u8          |    Mutable string slice                                            | `var buffer: []u8 = undefined;`                       |
| [N]T          |    Array of N elements of type T                                  | `var arr: [3]i32 = [_]i32{1, 2, 3};`                 |
| []T           |    Slice (runtime-known length)                                   | `var slice: []i32 = arr[0..2];`                       |
| *T            |    Single-item pointer                                             | `var ptr: *i32 = &num;`                               |
| [*]T          |    Many-item pointer (unknown length)                             | `var many_ptr: [*]u8 = undefined;`                    |
| ?T            |    Optional type (can be null)                                    | `var maybe: ?i32 = 5;`                                |
| !T            |    Error union type                                                | `var result: !i32 = 42;`                              |
| void          |    Zero-bit type                                                   | `fn doSomething() void { return; }`                   |
| noreturn      |    Type of functions that never return                            | `fn panic() noreturn { unreachable; }`                |

### Variable Declarations

Zig uses `var` for mutable variables and `const` for immutable values:

```zig
var count = @as(i32, 0); // Mutable variable
const MAX_SIZE: usize = 1000; // Immutable constant

// Type inference
const message = "Hello"; // Zig infers []const u8
var numbers = [_]i32{1, 2, 3}; // Zig infers [3]i32

// Explicit types
var age: u32 = 28;
const name: []const u8 = "Miguel";

// Undefined initialization
var buffer: [100]u8 = undefined;
```

### Functions

```zig
// Function with explicit types
fn add(x: i32, y: i32) i32 {
    return x + y;
}

// Function returning void
fn greet(name: []const u8) void {
    std.debug.print("Hello, {s}!\n", .{name});
}

// Function with optional parameter
fn greetWithTitle(name: []const u8, title: ?[]const u8) void {
    if (title) |t| {
        std.debug.print("Hello {} {s}\n", .{t, name});
    } else {
        std.debug.print("Hello {s}\n", .{name});
    }
}

// Function with comptime parameter
fn power(comptime T: type, base: T, exponent: T) T {
    var result: T = 1;
    var i: T = 0;
    while (i < exponent) : (i += 1) {
        result *= base;
    }
    return result;
}

// Function with slice parameter
fn sum(numbers: []const i32) i32 {
    var total: i32 = 0;
    for (numbers) |num| {
        total += num;
    }
    return total;
}
```

### Structs

```zig
// Basic struct
const Person = struct {
    first_name: []const u8,
    last_name: []const u8,
    age: u32,
    
    // Method (function inside struct)
    fn fullName(self: Person, allocator: std.mem.Allocator) ![]u8 {
        return std.fmt.allocPrint(allocator, "{s} {s}", .{self.first_name, self.last_name});
    }
    
    // Method that modifies self
    fn haveBirthday(self: *Person) void {
        self.age += 1;
    }
    
    // Associated function (no self parameter)
    fn init(first_name: []const u8, last_name: []const u8, age: u32) Person {
        return Person{
            .first_name = first_name,
            .last_name = last_name,
            .age = age,
        };
    }
};

// Generic struct
fn Point(comptime T: type) type {
    return struct {
        x: T,
        y: T,
        
        const Self = @This();
        
        fn init(x: T, y: T) Self {
            return Self{ .x = x, .y = y };
        }
        
        fn distance(self: Self) f64 {
            const dx = @as(f64, @floatFromInt(self.x));
            const dy = @as(f64, @floatFromInt(self.y));
            return @sqrt(dx * dx + dy * dy);
        }
    };
}
```

### Unions and Enums

```zig
// Tagged union (enum with data)
const Message = union(enum) {
    quit,
    move: struct { x: i32, y: i32 },
    write: []const u8,
    change_color: struct { r: u8, g: u8, b: u8 },
    
    fn process(self: Message) void {
        switch (self) {
            .quit => std.debug.print("Quit\n", .{}),
            .move => |coords| std.debug.print("Move to ({}, {})\n", .{coords.x, coords.y}),
            .write => |text| std.debug.print("Write: {s}\n", .{text}),
            .change_color => |color| std.debug.print("Color: ({}, {}, {})\n", .{color.r, color.g, color.b}),
        }
    }
};

// Simple enum
const Direction = enum {
    north,
    south,
    east,
    west,
    
    fn opposite(self: Direction) Direction {
        return switch (self) {
            .north => .south,
            .south => .north,
            .east => .west,
            .west => .east,
        };
    }
};

// Enum with explicit values
const HttpStatus = enum(u16) {
    ok = 200,
    not_found = 404,
    internal_server_error = 500,
};
```

### Error Handling

```zig
const std = @import("std");

// Error set
const MathError = error{
    DivisionByZero,
    NegativeSquareRoot,
};

// Function that can return error
fn divide(a: f64, b: f64) MathError!f64 {
    if (b == 0.0) {
        return MathError.DivisionByZero;
    }
    return a / b;
}

// Error handling with catch
fn safeDivision() void {
    const result = divide(10.0, 0.0) catch |err| switch (err) {
        MathError.DivisionByZero => {
            std.debug.print("Cannot divide by zero!\n", .{});
            return;
        },
        else => unreachable,
    };
    std.debug.print("Result: {}\n", .{result});
}

// Error handling with if
fn conditionalErrorHandling() void {
    if (divide(10.0, 2.0)) |result| {
        std.debug.print("Success: {}\n", .{result});
    } else |err| {
        std.debug.print("Error: {}\n", .{err});
    }
}

// Try operator
fn tryDivision() MathError!void {
    const result = try divide(10.0, 2.0);
    std.debug.print("Result: {}\n", .{result});
}
```

### Memory Management

```zig
const std = @import("std");

// Using allocator
fn memoryExample() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    
    // Allocate single value
    const ptr = try allocator.create(i32);
    defer allocator.destroy(ptr);
    ptr.* = 42;
    
    // Allocate slice
    const slice = try allocator.alloc(i32, 10);
    defer allocator.free(slice);
    
    for (slice, 0..) |*item, i| {
        item.* = @intCast(i);
    }
    
    // ArrayList (dynamic array)
    var list = std.ArrayList(i32).init(allocator);
    defer list.deinit();
    
    try list.append(1);
    try list.append(2);
    try list.append(3);
}

// Stack allocation with fixed buffer
fn stackMemoryExample() void {
    var buffer: [1024]u8 = undefined;
    var fba = std.heap.FixedBufferAllocator.init(&buffer);
    const allocator = fba.allocator();
    
    const slice = allocator.alloc(i32, 10) catch unreachable;
    // No need to free - memory is automatically reclaimed
}
```

### Optionals

```zig
// Optional types
const OptionalExample = struct {
    fn findValue(haystack: []const i32, needle: i32) ?usize {
        for (haystack, 0..) |value, index| {
            if (value == needle) {
                return index;
            }
        }
        return null;
    }
    
    fn handleOptional() void {
        const numbers = [_]i32{1, 2, 3, 4, 5};
        
        // Using if with optional
        if (findValue(&numbers, 3)) |index| {
            std.debug.print("Found at index: {}\n", .{index});
        } else {
            std.debug.print("Not found\n", .{});
        }
        
        // Using orelse for default value
        const index = findValue(&numbers, 10) orelse 999;
        std.debug.print("Index or default: {}\n", .{index});
    }
};
```

### Comptime

```zig
// Compile-time function
fn fibonacci(comptime n: u32) u32 {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
}

// Compile-time type generation
fn Vec(comptime T: type, comptime size: usize) type {
    return struct {
        data: [size]T,
        
        const Self = @This();
        
        fn init() Self {
            return Self{ .data = [_]T{0} ** size };
        }
        
        fn get(self: Self, index: usize) T {
            return self.data[index];
        }
        
        fn set(self: *Self, index: usize, value: T) void {
            self.data[index] = value;
        }
    };
}

// Usage of comptime types
fn comptimeExample() void {
    const Vec3f = Vec(f32, 3);
    var vector = Vec3f.init();
    vector.set(0, 1.0);
    vector.set(1, 2.0);
    vector.set(2, 3.0);
    
    // Compile-time fibonacci
    const fib_10 = comptime fibonacci(10);
    std.debug.print("Fibonacci(10) = {}\n", .{fib_10});
}
```

### Control Flow

```zig
// If statements
fn controlFlowExample() void {
    const x = 10;
    
    // Basic if
    if (x > 5) {
        std.debug.print("x is greater than 5\n", .{});
    } else if (x == 5) {
        std.debug.print("x is equal to 5\n", .{});
    } else {
        std.debug.print("x is less than 5\n", .{});
    }
    
    // While loop
    var i: u32 = 0;
    while (i < 5) {
        std.debug.print("i = {}\n", .{i});
        i += 1;
    }
    
    // While with continue expression
    var j: u32 = 0;
    while (j < 10) : (j += 1) {
        if (j % 2 == 0) continue;
        std.debug.print("Odd number: {}\n", .{j});
    }
    
    // For loop
    const numbers = [_]i32{1, 2, 3, 4, 5};
    for (numbers) |num| {
        std.debug.print("Number: {}\n", .{num});
    }
    
    // For loop with index
    for (numbers, 0..) |num, index| {
        std.debug.print("numbers[{}] = {}\n", .{index, num});
    }
    
    // Switch statement
    const day = 3;
    const day_name = switch (day) {
        1 => "Monday",
        2 => "Tuesday",
        3 => "Wednesday",
        4 => "Thursday",
        5 => "Friday",
        6, 7 => "Weekend",
        else => "Invalid day",
    };
    std.debug.print("Day: {s}\n", .{day_name});
}
```

### Testing

```zig
const std = @import("std");
const testing = std.testing;

// Test function
test "basic addition" {
    const result = add(2, 3);
    try testing.expect(result == 5);
}

test "division by zero" {
    const result = divide(10.0, 0.0);
    try testing.expectError(MathError.DivisionByZero, result);
}

test "optional handling" {
    const numbers = [_]i32{1, 2, 3, 4, 5};
    const index = OptionalExample.findValue(&numbers, 3);
    try testing.expect(index != null);
    try testing.expect(index.? == 2);
}

// Benchmark test
test "performance test" {
    var timer = try std.time.Timer.start();
    const start = timer.lap();
    
    // Some operation to benchmark
    _ = fibonacci(20);
    
    const end = timer.read();
    const duration = end - start;
    std.debug.print("Operation took {} nanoseconds\n", .{duration});
}
```

### Importing and Modules

```zig
const std = @import("std");
const builtin = @import("builtin");

// Import from relative path
const utils = @import("utils.zig");

// Public declarations (exported)
pub fn publicFunction() void {
    std.debug.print("This is public\n", .{});
}

// Private function (not exported)
fn privateFunction() void {
    std.debug.print("This is private\n", .{});
}

// Export for C
export fn c_function(x: c_int) c_int {
    return x * 2;
}

// Extern function from C
extern "c" fn malloc(size: usize) ?*anyopaque;
extern "c" fn free(ptr: ?*anyopaque) void;
```