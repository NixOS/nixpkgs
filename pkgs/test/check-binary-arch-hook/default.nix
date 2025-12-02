{
  lib,
  callPackage,
  pkgs,
  pkgsCross,
}:

lib.recurseIntoAttrs {
  # Test that cross-compilation works correctly (checks both /bin and /lib)
  crossCompilation = callPackage ./cross-compilation.nix { inherit pkgsCross; };
  # Test that wrong architecture is detected in cross-compilation (checks both /bin and /lib)
  crossWrongArch = callPackage ./cross-wrong-arch.nix { inherit pkgs pkgsCross; };
}
