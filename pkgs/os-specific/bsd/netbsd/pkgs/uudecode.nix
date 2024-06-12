{
  lib,
  mkDerivation,
  stdenv,
}:

mkDerivation {
  path = "usr.bin/uudecode";
  version = "9.2";
  sha256 = "00a3zmh15pg4vx6hz0kaa5mi8d2b1sj4h512d7p6wbvxq6mznwcn";
  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.isLinux "-DNO_BASE64";
  NIX_LDFLAGS = lib.optional stdenv.isDarwin "-lresolv";
}
