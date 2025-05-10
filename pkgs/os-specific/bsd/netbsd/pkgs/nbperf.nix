{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "usr.bin/nbperf";
  meta.platforms = lib.platforms.unix;
}
