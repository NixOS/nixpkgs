{
  trace ? false,
}:

let
  pkgs = import ../.. { config = import ./packages-config.nix; };
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
                  lib.map (x: {
                    name = x;
                    value = null;
                  }) value.outputs
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
