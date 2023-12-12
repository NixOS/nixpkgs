{ mkDerivation, lib, stdenv, ...}:
mkDerivation {
  path = "lib/libjail";
  MK_TESTS = "no";
  preBuild = lib.optionalString stdenv.cc.isClang ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D_VA_LIST_DECLARED"
  '';
}
