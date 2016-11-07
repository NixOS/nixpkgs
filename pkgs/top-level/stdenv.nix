{ system, bootStdenv, crossSystem, config, platform, lib, nixpkgsFun, pkgs }:

rec {
  allStdenvs = import ../stdenv {
    inherit system platform config crossSystem lib;
    allPackages = nixpkgsFun;
  };

  defaultStdenv = allStdenvs.stdenv // { inherit platform; };

  stdenv =
    if bootStdenv != null then
      (bootStdenv // { inherit platform; })
    else if crossSystem == null && config ? replaceStdenv then
      config.replaceStdenv {
        # We import again all-packages to avoid recursivities.
        pkgs = nixpkgsFun {
          # We remove packageOverrides to avoid recursivities
          config = removeAttrs config [ "replaceStdenv" ];
        };
      }
    else
      defaultStdenv;
}
