{ mkDerivation, libncurses-tinfo, ... }:
mkDerivation {
  path = "usr.bin/less";
  extraPaths = [
    "contrib/less"
  ];

  buildInputs = [ libncurses-tinfo ];
}
