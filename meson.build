project('mylib', 'cpp',
  version : '1.0.0',
  license : 'MIT',
  default_options: [
    'cpp_std=c++23',
    'build.cpp_std=c++23'
  ]
)
add_project_arguments(
  [
    '-Wall',
    '-Wextra',
    '-pedantic',
    '-Werror',
    '-Wconversion',
    '-Wshadow'
  ],
  language: 'cpp'
)

# dependencies

cmake = import('cmake')
cmake_opts = cmake.subproject_options()
cmake_opts.add_cmake_defines({
  'VALFUZZ_BUILD_SHARED': 'ON'
})
valfuzz_proj = cmake.subproject(
  'valfuzz',
  options: cmake_opts
)
valfuzz_dep = valfuzz_proj.dependency('valfuzz_shared')

# project

base_sources = files(
  'src/mylib.cpp'
)
if get_option('MYLIB_BUILD_SHARED')
  shared_library('mylib',
    sources: base_sources,
    include_directories: [
      'include',
    ],
    dependencies: [
      valfuzz_dep
    ],
  )
endif
if get_option('MYLIB_BUILD_STATIC')
  static_library('mylib',
    sources: base_sources,
    include_directories: [
      'include',
    ],
    dependencies: [
      valfuzz_dep
    ],
  )
endif
if get_option('MYLIB_BUILD_TESTS')
  test_sources = files(
    'tests/mylib_test.cpp',
    'fuzz/mylib_fuzz.cpp',
    'benchmarks/mylib_benchmark.cpp'
  )
  executable('tests',
    sources: [
      test_sources,
      base_sources
    ],
    include_directories: [
      'include',
    ],
    dependencies: [
      valfuzz_dep
    ],
  )
endif
