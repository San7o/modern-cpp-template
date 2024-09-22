# modern-c++template

This repo serves as a template for my C++ projects.

The template is composed of:

- [cmake](./CMakeLists.txt) build file, already configured for:
    - testing / fuzzing / benchmarking
    - static and dynamic library build
    - gcc or clang option with c++23
    - [CPM](https://github.com/cpm-cmake/CPM.cmake) as the default dependency manager
- [valFuzz](https://github.com/San7o/valFuzz) for testing, fuzzing and benchmarking
- [doxygen](./doxtgen.conf) documentation
- [clang-format](./.clang-format) settings
- [nix](./flake.nix) developement shell
- [LICENSE](./LICENSE), [CONTRIBUTING](./CONTRIBUTING.md) and other [git](./.gitattributes) files
- useful ready [commands](./Makefile)

## Building

### cmake
```bash
cmake -Bbuild
cmake --build build -j 4
```
### meson
```bash
meson setup build
ninja -C build
```

## Testing
```
cmake -Bbuild -DMYLIB_BUILD_TESTS=ON
cmake --build build -j 4
./build/tests --help
```
The library uses [valFuzz](https://github.com/San7o/valFuzz) for testing
```c++
./build/tests              # run tests
./build/tests --fuzz       # run fuzzer
./build/tests --benchmark  # run benchmarks
```

## Documentation

The library uses doxygen for documentation, to build the html documentation run:
```
make docs
```
