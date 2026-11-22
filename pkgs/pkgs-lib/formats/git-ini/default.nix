{
  pkgs,
  lib,
}:
let
  common = (import ../ini/default.nix { inherit pkgs lib; }).common;
  inherit (common)
    iniAtom
    ;

  inherit (lib.generators)
    toGitINI
    ;
  inherit (lib.types)
    attrsOf
    either
    ;
in
{
  format =
    {
      listsAsDuplicateKeys ? false,
      ...
    }:
    let
      atom = iniAtom {
        inherit listsAsDuplicateKeys;
        listToValue = null;
        atomsCoercedToLists = false;
      };
    in
    {
      type = attrsOf (attrsOf (either atom (attrsOf atom)));
      lib.types.atom = atom;
      generate = name: value: pkgs.writeText name (toGitINI value);
    };
}
