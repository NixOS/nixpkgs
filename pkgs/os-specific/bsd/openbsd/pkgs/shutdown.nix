{ mkDerivation }:
mkDerivation {
  path = "sbin/shutdown";

  preBuild = ''
    sed -i 's/4550/0550/' Makefile
  '';
}
