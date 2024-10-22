# Conan

This document contains a quick user guide on the conan packet manger.

If It's your first time using conan, you first need conan installed
in your system. Conan is already contained in the nix flake provided
by this repo.

Once you have conan installed, run the following to detect your system's
settings:

```bash
conan profile detect --force
```

To get the location of the configuration, run:
```bash
conan config home
```

You can now build the project:
```bash
conan install . --output-folder=build --build=missing
```

And do your usual cmake installation in the build directory.
