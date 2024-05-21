{
  lib,
  mkDerivation,
  sys,
}:

mkDerivation {
  pname = "libpci";
  path = "lib/libpci";
  version = "9.2";
  sha256 = "+IOEO1Bw3/H3iCp3uk3bwsFZbvCqN5Ciz70irnPl8E8=";
  env.NIX_CFLAGS_COMPILE = toString [ "-I." ];
  meta.platforms = lib.platforms.netbsd;
  extraPaths = [ sys.src ];
}
