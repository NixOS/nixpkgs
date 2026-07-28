{ lib, mkDerivation }:

mkDerivation {
  path = "usr.bin/cksum";
  meta.platforms = lib.platforms.netbsd;
}
