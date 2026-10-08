{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "lib/libdevdctl";
  clangFixup = false;

  outputs = [
    "out"
    "debug"
  ];

  env.NIX_CFLAGS_COMPILE = "-std=c++23 -Wno-nullability-completeness";

  meta.platforms = lib.platforms.freebsd;
}
