{
  lib,
  mkDerivation,
  libc,
  headers,
}:

mkDerivation {
  path = "lib/librt";
  meta.platforms = lib.platforms.netbsd;
  extraPaths = [ libc.path ] ++ libc.extraPaths;
  inherit (libc) postPatch;
}
