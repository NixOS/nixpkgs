{callPackage}:
let
  packages = callPackage ./packages.nix {};
in
  # For ergonomics
  packages.ghidra // {
   inherit (packages) withPlugins extend; # For ergonomics and overrides
   pkgs = packages; # For access
   }
