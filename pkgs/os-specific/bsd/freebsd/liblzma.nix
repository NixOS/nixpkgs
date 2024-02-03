{ mkDerivation, ... }:
mkDerivation {
  path = "lib/liblzma";
  extraPaths = ["contrib/xz/src/liblzma" "contrib/xz/src/common"];

  clangFixup = true;
}
