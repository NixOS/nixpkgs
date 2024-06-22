{
  lib,
  mkDerivation,
  libc,
}:

mkDerivation {
  path = "lib/libresolv";
  meta.platforms = lib.platforms.netbsd;
  extraPaths = [ libc.path ];
}
