{
  lib,
  mkDerivation,
}:
mkDerivation {
  path = "usr.bin/rpcgen";
  meta.platforms = lib.platforms.unix;
}
