# style

This document contains a collection of best practices and opinionated style for the project.

## Structure

- c++ header files are saved as `.hpp` while c headers are saved as `.h`.
- use `#pragma once` in every header file, unless high backward compatibility is a requirement.
- include a copy of the license in every file so that there is no ambiguity on the license if the code gets borrowed.
- use [Allman Style](https://en.wikipedia.org/wiki/Indentation_style#Allman_style), It's way easier to select blocks of code when editing files.
- never throw exceptions, don't be evil
- use exlicit namespaces in your code

## Performance

### Heap vs Stack
Heap allocations are the most expensive thinhs we commonly do, deallocations are the second
most expensive. The stack is contiguous so It has great locality of reference: unless something
is pretty big, if it has local scope and fixed size it should be on the stack.

### List vs. Deque vs. Vector
| Counts    | Container | Access Time (s) | Memory (GB) |
|-----------|-----------|-----------------|-------------|
| 10M/10    | List      | 8.1             | 4.34        |
|           | Deque     | 3.7             | 3.05        |
|           | Vector    | 2.5             | 1.29        |
| 1M/100    | List      | 6.7             | 3.33        |
|           | Deque     | 1.7             | 1.21        |
|           | Vector    | 2.3             | 0.50        |
| 100K/1000 | List      | 6.4             | 3.23        |
|           | Deque     | 1.4             | 1.03        |
|           | Vector    | 8.6             | 0.43        |

### RVO
- empty structs have size of 1, but if they are extended they have size 0 whanks to
**Empty Base Optimization**.
- compilers do **Return Value Optimization** when returning a temporary object or a
local variable (**Named Return Value Optimization**) unless:
    - there are multiple return paths where different objects are returned
    - a function parameter or a member value is returned
    - a non local object is returned
Don't return with `std::move` because it will inhibit RVO

### \__restrict\___

Use `__restrict__` when you are passing multiple pointers as arguments to a function.
This will tell the compiler that the pointers are not related so It can optimize your code:
```cpp
void test(int *__restrict__ arr, int *__restrict__ count)
{
    for (int i = 0; i < *count; i++)
    	arr[i] = 0;
}
```


### construct in place
When to construct in place:
- to avoid copying or moving
- with unmovable types
- to ensure lifetime stability
- to insert a default-constructed element
Do not use it
- when It's a copy anyway
- when you want to ensure that explicit constructors are not called
- when you want to use aggregate {} construction

### Misc
- `virual` functions are slow, avoid them.
- always use `const` when possible, you get constuction and initialization in one step.
- try to avoid branching as much as possible (I know this is not clear advice but keep It in mind)

## Functions

The most correct function signature looks like this:
```cpp
constexpr inline T a_func(const T& val) const noexcept;
```
The absence of a specifier form the previous example must be justified. For example:
- built-in types are as fast to pass as their reference
- pass things by value when you need to modify a copy

Remember that a const value cannot be moved, so It will be copied.

### Containers

Always use `std::array<T,N>` for storing a continuous amount of data. Use `std::vector` only when
really necessary. 

When `std::vector.clear()` is called, the vector is zeroed out but the memory is still allocated.

### Classes
A constructor with only one argument shall be `explicit`, unless this is not intentinally required.

Use `RAII`.

## Security

- Always use smart pointers for allocation
- Alyays test every function
- Compile with multiple compilers with as many checks as possible
- Use static code analyzers like `cppcheck`
- Always test with valgrind before committing your code.

## Examples

```cpp
// wrong
void use_value()
{
    std::string s; // default construct
    get_value(s);  // assign
}
// right
void use_value()
{
    std::string s = get_value();
}
```

```cpp
// cannot be optimized
for (int i = 0; i < N; i++) {
    if (A[i]%2) {
        C[i] = A[i] + B[i];
    }
    else {
        C[i] = A[i] - B[i];
    }
}
// simd optimization
for (int i = 0; i < N; i++) {  
    c[i] = (a[i] % 2) * b[i] * 2 - b[i] + a[i];  
}
```

## UB
``cpp
bool a; // uninitialized local variable
if (a)  // UB access to uninitialized scalar
    b = 42;
```
```cpp
auto&& x = max(0, 1);   // OK, so far
foo(x);                 // Undefined behavior
```

## Nice talks
- [Alan Talbot - Moving Faster: Everyday efficiency in modern C++](https://www.youtube.com/watch?v=EovBkh9wDnM&t=3080s)
- [Jason Turner - Great C++ is_trivial: trivial type traits](https://www.youtube.com/watch?v=bpF1LKQBgBQ&t=3106s)
