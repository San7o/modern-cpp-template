{
  description = "C++ development environment";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
  };

  outputs = { self, nixpkgs }: 
  let 
    supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
    
    # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
    forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

    # Nixpkgs instantiated for supported system types.
    pkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
  in
  {
    devShells = forAllSystems (system: {
      default =
        pkgsFor.${system}.mkShell.override {
          stdenv = pkgsFor.${system}.gcc14Stdenv;
        } {

          name = "c++-dev-shell";
          hardeningDisable = ["all"];
          packages = with pkgsFor.${system}; [
            gcc14                   # compiler
            cmake                   # build system
            meson                   # build system
            ninja                   # build system
            bazel_6                 # build system
            ccache                  # compiler cache
            valgrind                # memory debugger
            clang-tools             # code formatting
            gdb                     # debugger
            doxygen                 # documentation
            pre-commit              # git hooks
            libz.dev                # compression
            cppcheck                # static analysis
            llvmPackages.libcxxClang
            stdenv.cc.cc.lib
          ];
          shellHook = ''
              zsh
          '';

          LD_LIBRARY_PATH="${pkgsFor.${system}.libz.dev}:${pkgsFor.${system}.stdenv.cc.cc.lib}/lib";
          CMAKE_CXX_COMPILER="${pkgsFor.${system}.gcc14}/bin/:${pkgsFor.${system}.clang_18}/bin/";
        };
    });
  };
}
