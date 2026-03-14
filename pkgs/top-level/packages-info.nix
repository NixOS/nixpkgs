{
  trace ? false,
  supportedSystems,
}:

let
  pkgsSystems =
    if builtins.all (v: v != builtins.currentSystem) supportedSystems then
      supportedSystems ++ [ builtins.currentSystem ]
    else
      supportedSystems;

  pkgsByArch = builtins.listToAttrs (
    map (system: {
      name = system;
      value = import ../.. {
        inherit system;
        config = import ./packages-config.nix;
      };
    }) pkgsSystems
  );

  pkgs = pkgsByArch.${builtins.currentSystem};

  inherit (pkgs) lib;

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
              value = {
                inherit (value)
                  meta
                  name
                  outputName
                  system
                  ;
                ${if value ? "outputs" then "outputs" else null} = lib.listToAttrs (
                  lib.map (
                    x:
                    let
                      platforms = lib.intersectLists (value.meta.hydraPlatforms
                        or (lib.subtractLists (value.meta.badPlatforms or [ ]) (value.meta.platforms or supportedSystems))
                      ) supportedSystems;

                      outPaths = lib.listToAttrs (
                        lib.map (
                          platform:
                          let
                            drvForPlatform =
                              if lib.hasAttrByPath path pkgsByArch.${platform} then
                                lib.getAttrFromPath path pkgsByArch.${platform}
                              else
                                null;
                            outPath =
                              if builtins.isAttrs drvForPlatform && drvForPlatform ? ${x}.outPath then
                                builtins.unsafeDiscardStringContext drvForPlatform.${x}.outPath
                              else
                                null;
                            eval = builtins.tryEval outPath;
                          in
                          {
                            name = platform;
                            value = if eval.success then eval.value else null;
                          }
                        ) platforms
                      );
                    in
                    {
                      name = x;
                      value = (builtins.tryEval outPaths).value or null;
                      # value = null;
                    }
                  ) value.outputs
                );
                # TODO: Remove the following two fallbacks when all packages have been fixed.
                # Note: pname and version are *required* by repology, so do not change to
                # the optional pattern from above.
                pname = value.pname or value.name;
                version = value.version or "";
              };
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
in
lib.strings.toJSON {
  version = "2";
  packages = lib.listToAttrs (generateInfo [ ] (lib.recurseIntoAttrs pkgs));
}
