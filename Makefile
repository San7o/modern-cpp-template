.PHONY: format docs check update

format:
	find include src tests benchmarks fuzz -iname "*.cpp" -o -iname "*.hpp" | xargs clang-format -i

docs:
	doxygen doxygen.conf

check:
	cppcheck --enable=all include/mylib/*.hpp --suppress=unusedFunction -I include  --suppress=missingIncludeSystem --quiet --error-exitcode=1

update:
	meson subprojects update
