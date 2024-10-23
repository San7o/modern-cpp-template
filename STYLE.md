# style

## Abstract

The complexity of modern C++ poses significant challenges for collaborative
code development across different teams and time frames. Variations in the
interpretation of correctness and best practices can lead to inconsistencies
in the codebase. This manuscript presents an opinionated collection of best practices
and stylistic guidelines, specifically tailored to ensure consistency and
maintainability within the project.

## On Correctnes

What is correctness? It is safe to say that a program is correct if It compiles
without errors. While there is truth in this statement, correctness is not so
simple to define. Consider the following example: I want to pass a variable
to a function that only performs read operations on the variable. I may pass
the variable by copy, by reference or by const reference. Even if all these options
are valid programs, I would argue that one is more correct over the others given
a specific context. But what if I did not know that you could pass a value by
referece? I would consider the pass by copy as correct and move on in life, which
is not good for the codebase.
This can happen everywhere in the code so we should look for external resources for guidance.
Some standards have been compiled such as [C++ Coding Guidelines](https://isocpp.github.io/CppCoreGuidelines/CppCoreGuidelines)
and [MISRA C++](https://misra.org.uk/misra-cpp2023-released-including-hardcopy/), and
tools were written to automaically check the complience to these rules such as
[cppcheck](https://github.com/danmar/cppcheck). So did we solve the problem? Is a
program correct if It follows these guidelines? I think It is more complex than this
and It may be true that a general formula for correctness may not exist and everything
is subjective, such as beauty. So in my attempts to write what I consider C++ code to
be correct, I decided to write this manuscipt to express what I consider "beautiful code"
and the principles I follow on my own code that are my definition of correctness.

## Developement Process

When talking about C++ correctness, we have to also talk about the process of designing
and implementing code such as a library. To prevent wasting time when writing code, It
is useful to first write down the structure of the codebase, It's data structures and interfaces,
and then start writing code. Now, In an ideal world we would all do this, but in the
world we live in time is a finite resource. Therefore a balance is needed between designing
and writing code, and It's a difficult skill to develop. As any engeneering project, a programmer
should first split the big problem into smaller problems recursively until he/she feels satisfied
and have a decent plan to implement. This is good enough for smal / medium sized projects
and requires more attention on big projects where multiple people are involved. The process
may vary extensively between projects so I won't stress you much on this point.

## Testing

After writing some stable code, everything must be thoroughly tested. I will put this clearely: **you cannot
assume that your code works if you did not write a bunch of testcases to test it**, covering
all the cornercases you can find. When discussing optimizations and changes reguarding performance,
you should always **benchmark** you application. The user's api must be also **fuzzed** extensively
because you never know if you actually found all test cases or not.

## Documentation

A good project has good documentation explaining in natural language how the system works on a higher
level ov abstraction. It's mostly useless to have code documentation on single functions that
just explain what the function does: you should be able to understand It clearly as you used
a good and intuitive name and expressed the constraints with the type system. The documentation
should explain at large how a function should be used and why, with some context and examples.

## Structure & Style

- c++ header files are saved as `.hpp` while c headers are saved as `.h`. Header files should be placed in a dedicated
directory separated from the source files so that the user of the library can just copy the headers directory into Its
project and be good to go.
- use `#pragma once` in every header file, I consider `#ifndef` depricated.
- include a copy of the license in every file so that there is no ambiguity on the license if the code gets borrowed.
- use [Allman Style](https://en.wikipedia.org/wiki/Indentation_style#Allman_style), It's way easier to select blocks of code when editing files.
- never throw exceptions, don't be evil
- use explicit namespaces in your code

## Performance

I think that a more performant program is a more correct program, so we should
care about performance to write correct applications.

### Heap vs Stack
Heap allocations are the most expensive things we commonly do, deallocations are the second
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

### Caches
| **Memory Type** | **Typical Access Time** | **Clock Cycles** | **Size**           | **Location**        | **Purpose**                                  |
|-----------------|-------------------------|------------------|--------------------|---------------------|----------------------------------------------|
| **Registers**    | 1 ns                    | 1 cycle          | 32 - 512 bits      | CPU                 | Store immediate data for processing          |
| **L1 Cache**     | 0.5 - 2 ns              | 3 - 5 cycles     | 32 KB - 128 KB      | CPU (Core)          | Fast access for frequently used data         |
| **L2 Cache**     | 3 - 10 ns               | 10 - 20 cycles   | 256 KB - 1 MB       | CPU (Chip)          | Store data shared by L1 caches               |
| **L3 Cache**     | 10 - 30 ns              | 20 - 40 cycles   | 2 MB - 128 MB       | CPU (Shared across cores) | Store less frequently accessed data |
| **RAM (DRAM)**   | 50 - 100 ns             | 100 - 200 cycles | 4 GB - 64 GB        | Motherboard         | Primary working memory for active processes  |
| **SSD (NVMe)**   | 0.1 - 1 ms              | 100,000+ cycles  | 128 GB - 2 TB       | Storage Device      | Fast persistent storage for data and files   |
| **HDD**          | 5 - 15 ms               | Millions of cycles | 1 TB - 10 TB      | Storage Device      | Slower, cheaper persistent storage           |

### Optimizations
- empty structs have size of 1, but if they are extended they have size 0 size thanks to
**Empty Base Optimization**.
- compilers do **Return Value Optimization** when returning a temporary object or a
local variable (**Named Return Value Optimization**) unless:
    - there are multiple return paths where different objects are returned
    - a function parameter or a member value is returned
    - a non local object is returned

Don't return with `std::move` because it will inhibit RVO, unless RVO is not applied.

Look [here](https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html) for gcc's optimization flags.

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
Note that this only works for GCC. You can add this three lines so that the code can compile on each compiler.
```cpp
#ifndef __GNUC__
#define __restrict__ 
#endif
```

### Alignment
Consider the following example:
```cpp
struct s1 {
    char c;
    int i[2];
    double v;
};
```
You might think that It takes 1 + (4*2) + 8 = 17 bytes in memory, but It actually takes 24 (you can check this using `sizeof()`).
This is because each variable must be aligned to a multiple of It's size, for example `int` is 4 bytes
so It will need to pad 3 bytes after the char. Unfortunately, we cannot rewrite this any better because the struct must terminate
at an 8 byte offset because It might be in an array and It needs to be aligned.

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
- linked lists are the worst thing possible (adios cache)
- also `std::map` is even worse, because you have all the problems of a linked list, plus you
need to rebance the tree every time.
- btw, `std::unordered_map` is also shit because it uses linked lists for buckets, so It's always
a cache miss.

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
- A constructor with only one argument shall be `explicit`, unless this is not intentinally required.
- Use `RAII`.

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
// wrong
std::vector<T> result;
for (int i = 0; i < n; ++i)
    result.push_back(T());
// right
std::vector<T> result;
result.reserve(n);
for (int i = 0; i < n; ++i=
    result.push_back(n);
```

```cpp
X *getX(std::string key, std::unordered_map<std::string, std::unique_ptr<X> &cache)
{
    if (cache[key])
        return cache[key].get();

    cache[key] ) std::make_unique<X>();
    return cache[key].get();
}
// this code computes the hash of key 4 times, which is not nice. We could have just added
// std::unique_ptr<X> entry = cache[key];
// and use this
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
```cpp
bool a; // uninitialized local variable
if (a)  // UB access to uninitialized scalar
    b = 42;
```
```cpp
auto&& x = max(0, 1);   // OK, so far
foo(x);                 // Undefined behavior
```

## __cplusplus versions
 - 199711L(until C++11)
 - 201103L(C++11)
 - 201402L(C++14)
 - 201703L(C++17)
 - 202002L(C++20)
 - 202302L(C++23)

## Nice talks
- [Alan Talbot - Moving Faster: Everyday efficiency in modern C++](https://www.youtube.com/watch?v=EovBkh9wDnM): tips and tricks for efficiency
- [Jason Turner - Great C++ is_trivial: trivial type traits](https://www.youtube.com/watch?v=bpF1LKQBgBQ): lots of examples
- [Chandler Carruth - Understanding Compiler Optimization](https://www.youtube.com/watch?v=fHNmRkzxHWs): good introduction to the inner working of the compiler
