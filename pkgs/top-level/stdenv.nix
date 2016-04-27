{ system, bootStdenv, crossSystem, config, platform, lib, nixpkgsFun }:

rec {
  allStdenvs = import ../stdenv {
    inherit system platform config crossSystem lib;
    allPackages = nixpkgsFun;
  };

  defaultStdenv = allStdenvs.stdenv // { inherit platform; };

  stdenv =
    if bootStdenv != null
    then (bootStdenv // { inherit platform; })
    else defaultStdenv;
}
