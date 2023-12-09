{ mkDerivation, ...}:
mkDerivation {
  path = "lib/libutil";
  extraPaths = ["lib/libc/gen"];
  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D_VA_LIST_DECLARED -D_SIZE_T"
  '';
  MK_TESTS = "no";
}
