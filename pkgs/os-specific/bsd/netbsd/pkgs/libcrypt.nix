{ lib, mkDerivation }:

mkDerivation {
  path = "lib/libcrypt";

  libcMinimal = true;

  outputs = [
    "out"
    "man"
  ];

  SHLIBINSTALLDIR = "$(out)/lib";
  meta.platforms = lib.platforms.netbsd;
}
