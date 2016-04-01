{ system, bootStdenv, crossSystem, config, platform, lib, ... }:
self: super:

with super;

rec {
  allStdenvs = import ../stdenv {
    inherit system platform config lib;
    allPackages = args: import ./../.. ({ inherit config system; } // args);
  };

  defaultStdenv = allStdenvs.stdenv // { inherit platform; };

  stdenv =
    if bootStdenv != null then (bootStdenv // {inherit platform;}) else
      if crossSystem != null then
        stdenvCross
      else
        let
            changer = config.replaceStdenv or null;
        in if changer != null then
          changer {
            # We import again all-packages to avoid recursivities.
            pkgs = import ./../.. {
              # We remove packageOverrides to avoid recursivities
              config = removeAttrs config [ "replaceStdenv" ];
            };
          }
      else
        defaultStdenv;
}
