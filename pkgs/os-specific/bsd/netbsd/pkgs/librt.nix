{
  lib,
  mkDerivation,
  libcMinimal,
}:

mkDerivation {
  path = "lib/librt";

  libcMinimal = true;

  outputs = [
    "out"
    "man"
  ];

  extraPaths = [ libcMinimal.path ] ++ libcMinimal.extraPaths;

  inherit (libcMinimal) postPatch;

  meta.platforms = lib.platforms.netbsd;
}
