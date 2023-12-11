{ mkDerivation, ...}:
mkDerivation {
  path = "lib/libjail";
  MK_TESTS = "no";
  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D_VA_LIST_DECLARED"
  '';
}
