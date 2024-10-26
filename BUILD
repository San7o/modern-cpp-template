cc_library(
    name = "mylib",
    srcs = glob([
        "src/*.cpp",
        "include/mylib/*.hpp"
    ]),
    hdrs = glob([
        "include/mylib/*.hpp"
    ]),
    includes = ["include"],
    copts = [
        "-Iinclude",
        "-std=c++23",
        "-O3",
        "-Wall",
        "-Wextra",
        "-pedantic",
        "-Werror",
        "-Wconversion",
        "-Wshadow",
    ],
    visibility = ["//visibility:public"],
)

cc_binary(
    name = "tests",
    srcs = glob([
        "tests/*.cpp",
        "benchmarks/*.cpp",
        "fuzz/*.cpp",
    ]),
    includes = ["include"],
    copts = [
        "-Iinclude",
        "-std=c++23",
        "-O3",
        "-Wall",
        "-Wextra",
        "-pedantic",
        "-Werror",
        "-Wconversion",
        "-Wshadow",
    ],
    deps = [
        "@valfuzz//:libvalfuzz",
        ":mylib",
    ],
)
