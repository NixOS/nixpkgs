{
  lib,
  mkDerivation,
  sys,
}:

mkDerivation {
  path = "lib/libm";
  SHLIBINSTALLDIR = "$(out)/lib";
  meta.platforms = lib.platforms.netbsd;
  extraPaths = [ sys.path ];
}
