{ mkDerivation }:
mkDerivation {
  path = "sbin/shutdown";

  MK_TESTS = "no";
  preBuild = ''
    sed -i 's/4554/0554/' Makefile
  '';
}
