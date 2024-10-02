cc_library(
    name = "mylib",
    srcs = ["mylib.cpp"],
    hdrs = ["//include/mylib:mylib.hpp"],  # Refer to the header in the `include/mylib` directory
    includes = ["//include"],  # Add the base include directory to the include path
    copts = ["-Iinclude"],
    visibility = ["//visibility:public"],  # Allow the main package to depend on this library
)
