{
  lib,
  mkDerivation,
  stdenv,
}:

mkDerivation {
  path = "usr.bin/uudecode";
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isLinux "-DNO_BASE64";
  NIX_LDFLAGS = lib.optional stdenv.isDarwin "-lresolv";
}
