{
  lib,
  mkDerivation,
  libcMinimal,
}:

mkDerivation {
  path = "lib/libresolv";

  libcMinimal = true;

  extraPaths = [ libcMinimal.path ];

  meta.platforms = lib.platforms.netbsd;
}
