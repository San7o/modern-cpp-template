# modern-c++template

This repo serves as a template for my C++ projects.

The template is composed of:

- [cmake](./CMakeLists.txt), [meson](./meson.build) and [bazel](https://bazel.build/) build files, already configured for:
    - testing / fuzzing / benchmarking
    - static and dynamic library build
    - gcc or clang option with c++23
    - [CPM](https://github.com/cpm-cmake/CPM.cmake) as cmake dependency manager
- [valFuzz](https://github.com/San7o/valFuzz) for testing, fuzzing and benchmarking
- [doxygen](./doxtgen.conf) documentation
- [clang-format](./.clang-format) settings
- [nix](./flake.nix) developement shell
- [cppcheck](https://cppcheck.sourceforge.io/) for static analysis 
- [LICENSE](./LICENSE), [CONTRIBUTING](./CONTRIBUTING.md) and other [git](./.gitattributes) files
- github workflow
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
### bazel
```bash
bazel build //src:mylib --sandbox_debug --verbose_failures
```
The binaries will be generated in `bazel-build`

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

## Change name
To change the name of the template, run:
```bash
./set-name <your-name>
```
