{
  lib,
  mkDerivation,
  sys,
}:

mkDerivation {
  path = "lib/libm";
  version = "9.2";
  sha256 = "1apwfr26shdmbqqnmg7hxf7bkfxw44ynqnnnghrww9bnhqdnsy92";
  SHLIBINSTALLDIR = "$(out)/lib";
  meta.platforms = lib.platforms.netbsd;
  extraPaths = [ sys.src ];
}
