{ system, bootStdenv, crossSystem, config, platform, lib, nixpkgsFun, ... }:
pkgs:

rec {
  allStdenvs = import ../stdenv {
    inherit system platform config lib;
    # TODO(@Ericson2314): hack for cross-compiling until I clean that in follow-up PR
    allPackages = args: nixpkgsFun (args // { crossSystem = null; });
  };

  defaultStdenv = allStdenvs.stdenv // { inherit platform; };

  stdenv =
    if bootStdenv != null then (bootStdenv // {inherit platform;}) else
      if crossSystem != null then
        pkgs.stdenvCross
      else
        let
            changer = config.replaceStdenv or null;
        in if changer != null then
          changer {
            # We import again all-packages to avoid recursivities.
            pkgs = nixpkgsFun {
              # We remove packageOverrides to avoid recursivities
              config = removeAttrs config [ "replaceStdenv" ];
            };
          }
      else
        defaultStdenv;
}
