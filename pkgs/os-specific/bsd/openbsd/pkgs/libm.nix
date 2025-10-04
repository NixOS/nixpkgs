{ lib, mkDerivation }:

mkDerivation {
  path = "lib/libm";

  libcMinimal = true;

  outputs = [
    "out"
    "man"
  ];

  extraPaths = [ "sys" ];

  meta.platforms = lib.platforms.openbsd;
}
