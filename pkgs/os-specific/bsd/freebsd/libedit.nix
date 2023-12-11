{ mkDerivation, libncurses-tinfo, ...}:
mkDerivation {
  path = "lib/libedit";
  extraPaths = ["contrib/libedit"];
  buildInputs = [libncurses-tinfo];
  MK_TESTS = "no";

  preBuild = ''
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -D_VA_LIST_DECLARED -D_SIZE_T -D_WCHAR_T"
  '';
}
