{ mkDerivation, buildPackages }:
mkDerivation {
  path = "lib/libipsec";

  extraNativeBuildInputs = [
    buildPackages.byacc
    buildPackages.flex
  ];
}
