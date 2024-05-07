{
  lib,
  mkDerivation,
  libc,
}:

mkDerivation {
  path = "lib/libresolv";
  version = "9.2";
  sha256 = "1am74s74mf1ynwz3p4ncjkg63f78a1zjm983q166x4sgzps15626";
  meta.platforms = lib.platforms.netbsd;
  extraPaths = [ libc.src ];
}
