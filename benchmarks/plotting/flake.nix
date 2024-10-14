{
  description = "python uv development environment";

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

          name = "python-dev-shell";
          hardeningDisable = ["all"];
          packages = with pkgsFor.${system}; [
            gcc14                   # compiler
            stdenv.cc.cc.lib
            python312               # python 3.12 (stable)
            python312Packages.uv    # Python project manager

            # need those for numpy
            glib
            libz
            zlib
            # You need the following only if you are on wayland
            xorg.libX11
            xorg.libxcb
            xorg.libICE
            xorg.libSM
            xorg.libXext
          ];
          shellHook = ''
              export PYTHONPATH="$(pwd)"
              zsh
          '';

          LD_LIBRARY_PATH="${pkgsFor.${system}.libz}/lib:${pkgsFor.${system}.stdenv.cc.cc.lib}/lib:${pkgsFor.${system}.zlib}/lib";
          CMAKE_CXX_COMPILER="${pkgsFor.${system}.gcc14}/bin/:${pkgsFor.${system}.clang_18}/bin/";
        };
    });
  };
}
