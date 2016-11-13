{ system, bootStdenv, crossSystem, config, platform, lib, nixpkgsFun }:

rec {
  defaultStdenv = import ../stdenv {
    inherit system platform config crossSystem lib;
    allPackages = nixpkgsFun;
  } // { inherit platform; };

  stdenv =
    if bootStdenv != null
    then (bootStdenv // { inherit platform; })
    else defaultStdenv;
}
