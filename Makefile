.PHONY: format docs

format:
	find include src tests benchmarks fuzz -iname "*.cpp" -o -iname "*.hpp" | xargs clang-format -i

docs:
	doxygen doxygen.conf
