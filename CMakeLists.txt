cmake_minimum_required(VERSION 3.20)
project(
    mylib 
    VERSION 1.0
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 23 REQUIRED)
set(CMAKE_THREAD_LIBS_INIT "-lpthread")
set(CMAKE_HAVE_THREADS_LIBRARY 1)
set(CMAKE_USE_WIN32_THREADS_INIT 0)
set(CMAKE_USE_PTHREADS_INIT 1)
set(THREADS_PREFER_PTHREAD_FLAG ON)

set(MYLIB_SOURCES src/mylib.cpp)
set(MYLIB_HEADERS include)
set(MYLIB_COMPILE_OPTIONS -Wall -Wextra -Wpedantic -Werror -Wconversion -Wshadow)
set(MYLIB_TEST_SOURCES
        tests/mylib_test.cpp
        fuzz/mylib_fuzz.cpp
        benchmarks/mylib_benchmark.cpp
)
set(MYLIB_TEST_HEADERS)

option(MYLIB_USE_CLANG "Use clang" OFF)
option(MYLIB_BUILD_TESTS "Build tests" ON)
option(MYLIB_BUILD_SHARED "Build shared library" OFF)
option(MYLIB_BUILD_STATIC "Build static library" OFF)

include(cmake/CPM.cmake) # <3
CPMUsePackageLock(package-lock.cmake)
CPMAddPackage(
    NAME valfuzz
    GITHUB_REPOSITORY San7o/valFuzz
    GIT_TAG v1.0.1
    DOWNLOAD_ONLY True
)
if (valfuzz_ADDED)
    list(APPEND MYLIB_TEST_SOURCES ${valfuzz_SOURCE_DIR}/src/valfuzz.cpp)
    list(APPEND MYLIB_TEST_HEADERS ${valfuzz_SOURCE_DIR}/include)
endif()

if(MYLIB_USE_CLANG)
    set(CMAKE_CXX_COMPILER clang++)
endif()

if(MYLIB_BUILD_SHARED)
    add_library(mylib_shared SHARED ${MYLIB_SOURCES})
    target_include_directories(mylib_shared PRIVATE ${MYLIB_HEADERS})
    target_compile_options(mylib_shared PRIVATE ${MYLIB_COMPILE_OPTIONS})
    if (MYLIB_USE_CLANG)
        target_compile_options(mylib_shared PRIVATE -std=c++23 -fexperimental-library)
        target_link_libraries(mylib_shared PRIVATE -fexperimental-library)
    endif()
endif()

if(MYLIB_BUILD_STATIC)
    add_library(mylib_static STATIC ${MYLIB_SOURCES})
    target_include_directories(mylib_static PRIVATE ${MYLIB_HEADERS})
    target_compile_options(mylib_static PRIVATE ${MYLIB_COMPILE_OPTIONS})
    if (MYLIB_USE_CLANG)
        target_compile_options(mylib_static PRIVATE -std=c++23 -fexperimental-library)
        target_link_libraries(mylib_static PRIVATE -fexperimental-library)
    endif()
endif()

if(MYLIB_BUILD_TESTS AND valfuzz_ADDED)
    add_executable(tests ${MYLIB_SOURCES} ${MYLIB_TEST_SOURCES})
    target_include_directories(tests PRIVATE ${MYLIB_HEADERS} ${MYLIB_TEST_HEADERS})
    target_compile_options(tests PRIVATE ${MYLIB_COMPILE_OPTIONS})
    if (MYLIB_USE_CLANG)
        target_compile_options(tests PRIVATE -std=c++23 -fexperimental-library)
        target_link_libraries(tests PRIVATE -fexperimental-library)
    endif()
endif()
