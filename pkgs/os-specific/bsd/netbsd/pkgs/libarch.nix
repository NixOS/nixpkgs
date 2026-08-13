{ lib, mkDerivation }:

mkDerivation {
  path = "lib/libarch";
  meta.platforms = lib.platforms.netbsd;
}
