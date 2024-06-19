{ lib, mkDerivation }:

mkDerivation {
  path = "lib/libcrypt";
  SHLIBINSTALLDIR = "$(out)/lib";
  meta.platforms = lib.platforms.netbsd;
}
