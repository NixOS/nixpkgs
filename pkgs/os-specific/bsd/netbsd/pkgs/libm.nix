{ lib, mkDerivation }:

mkDerivation {
  path = "lib/libm";

  libcMinimal = true;

  outputs = [
    "out"
    "man"
  ];

  SHLIBINSTALLDIR = "$(out)/lib";

  extraPaths = [ "sys" ];

  meta.platforms = lib.platforms.netbsd;
}
