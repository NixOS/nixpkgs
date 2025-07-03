{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "usr.bin/getent";
  patches = [ ./getent.patch ];

  meta.platforms = lib.platforms.unix;
}
