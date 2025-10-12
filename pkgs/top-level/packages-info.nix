{
  path ? ../..,
  packages-config ? import ./packages-config.nix,
  lib ? import ../../lib,
  trace ? false,
}:

let
  pkgs = import path { config = packages-config; };
  generateInfo =
    path: value:
    let
      result =
        if path == [ "AAAAAASomeThingsFailToEvaluate" ] || !(lib.isAttrs value) then
          [ ]
        else if lib.isDerivation value then
          [
            {
              name = lib.showAttrPath path;
              value =
                lib.optionalAttrs (value ? "meta") { meta = value.meta; }
                // lib.optionalAttrs (value ? "name") { name = value.name; }
                // lib.optionalAttrs (value ? "outputName") { outputName = value.outputName; }
                // lib.optionalAttrs (value ? "outputs") { outputs = value.outputs; }
                // lib.optionalAttrs (value ? "pname") { pname = value.pname; }
                // lib.optionalAttrs (value ? "system") { system = value.system; }
                // lib.optionalAttrs (value ? "version") { version = value.version; };
            }
          ]
        else if value.recurseForDerivations or false then
          lib.pipe value [
            (lib.mapAttrsToList (
              name: value:
              lib.addErrorContext "while evaluating package set attribute path '${
                lib.showAttrPath (path ++ [ name ])
              }'" (generateInfo (path ++ [ name ]) value)
            ))
            lib.concatLists
          ]
        else
          [ ];
    in
    lib.traceIf trace "** ${lib.showAttrPath path}" (lib.deepSeq result result);

  packages-info = {
    version = "2";
    packages = lib.listToAttrs (generateInfo [ ] (lib.recurseIntoAttrs pkgs));
  };
in
pkgs.stdenvNoCC.mkDerivation {
  pname = "packages-info";
  inherit (packages-info) version;

  dontUnpack = true;
  dontBuild = true;

  passthru = { inherit packages-info; };

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    cat ${builtins.toFile "packages.json" (lib.strings.toJSON packages-info)} | sed "s|${path}/||g" > $out/packages.json

    runHook postInstall
  '';

  meta = {
    maintainers = with lib.maintainers; [ jopejoe1 ];
    platforms = lib.platforms.all;
    license = lib.licenses.mit;
    description = "Information about packages included in nixpkgs";
  };
}
