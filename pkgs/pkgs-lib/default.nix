# pkgs-lib is for functions and values that can't be in lib because
# they depend on some packages. This notably is *not* for supporting package
# building, instead pkgs/build-support is the place for that.
{ lib, pkgs }:
{
  # setting format types and generators. These do not fit in lib/types.nix,
  # because they depend on pkgs for rendering some formats
  formats = import ./formats.nix {
    inherit lib pkgs;
  };

  # module system type and builder for generated files. These do not fit in
  # lib/types.nix, because they depend on pkgs to build the files
  generatedFiles = import ./generated-files.nix {
    inherit lib pkgs;
  };

  # module system evaluation that maps the options of a program to its
  # configuration files. It depends on pkgs to build the files
  configFiles = import ./config-files.nix {
    inherit lib pkgs;
  };
}
