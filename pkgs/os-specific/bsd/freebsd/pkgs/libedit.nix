{ mkDerivation, libncurses-tinfo }:
mkDerivation {
  path = "lib/libedit";
  extraPaths = [ "contrib/libedit" ];
  buildInputs = [ libncurses-tinfo ];
  MK_TESTS = "no";
}
