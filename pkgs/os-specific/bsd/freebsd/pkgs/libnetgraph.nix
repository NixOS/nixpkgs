{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "lib/libnetgraph";

  outputs = [
    "out"
    "man"
    "debug"
  ];

  meta.platforms = lib.platforms.freebsd;
}
