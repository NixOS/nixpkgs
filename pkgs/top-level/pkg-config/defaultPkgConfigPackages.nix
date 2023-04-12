/* A set of aliases to be used in generated expressions.

   In case of ambiguity, this will pick a sensible default.

   This was initially based on cabal2nix's mapping.

   It'd be nice to generate this mapping, based on a set of derivations.
   It can not be fully automated, so it should be a expression or tool
   that makes suggestions about which pkg-config module names can be added.
 */
pkgs:

let
  inherit (pkgs) lib;
  inherit (lib)
    all
    flip
    mapAttrs
    mapAttrsToList
    getAttrFromPath
    importJSON
    ;

  data = importJSON ./pkg-config-data.json;
  inherit (data) modules;

  platform = pkgs.stdenv.hostPlatform;

  isSupported = moduleData:
    moduleData?supportedWhenPlatformAttrsEqual ->
      all (x: x) (
        mapAttrsToList
          (k: v: platform?${k} && platform.${k} == v)
          moduleData.supportedWhenPlatformAttrsEqual
      );

  modulePkgs = flip mapAttrs modules (_moduleName: moduleData:
    if moduleData?attrPath && isSupported moduleData then
      getAttrFromPath moduleData.attrPath pkgs
    else
      null
  );

in
  modulePkgs
