{
  lib,
  mkDerivation,
  sys,
}:

mkDerivation {
  pname = "libpci";
  path = "lib/libpci";
  env.NIX_CFLAGS_COMPILE = toString [ "-I." ];
  meta.platforms = lib.platforms.netbsd;
  extraPaths = [ sys.path ];
}
