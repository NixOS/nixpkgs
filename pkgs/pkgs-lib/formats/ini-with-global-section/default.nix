{
  pkgs,
  lib,
}:
let
  common = (import ../ini/default.nix { inherit pkgs lib; }).common;
  inherit (common)
    ignoredArgs
    iniAtom
    iniSection
    maybeCoerceAllLists
    maybeCoerceList
    ;

  inherit (lib)
    mkOption
    ;
  inherit (lib.generators)
    toINIWithGlobalSection
    ;
  inherit (lib.types)
    attrsOf
    submodule
    ;
in
{
  format =
    {
      # Represents lists as duplicate keys
      listsAsDuplicateKeys ? false,
      # Alternative to listsAsDuplicateKeys, converts list to non-list
      # listToValue :: [IniAtom] -> IniAtom
      listToValue ? null,
      # Merge multiple instances of the same key into a list
      atomsCoercedToLists ? null,
      ...
    }@args:
    assert listsAsDuplicateKeys -> listToValue == null;
    assert atomsCoercedToLists != null -> (listsAsDuplicateKeys || listToValue != null);
    let
      atomsCoercedToLists' = if atomsCoercedToLists == null then false else atomsCoercedToLists;
      atom = iniAtom {
        inherit listsAsDuplicateKeys listToValue;
        atomsCoercedToLists = atomsCoercedToLists';
      };
    in
    {
      type = submodule {
        options = {
          sections = mkOption rec {
            type = attrsOf (iniSection atom);
            default = { };
            description = type.description;
          };
          globalSection = mkOption rec {
            type = iniSection atom;
            default = { };
            description = "global " + type.description;
          };
        };
      };
      lib.types.atom = atom;
      generate =
        name:
        {
          sections ? { },
          globalSection ? { },
          ...
        }:
        pkgs.writeText name (
          toINIWithGlobalSection (removeAttrs args ignoredArgs) {
            globalSection = maybeCoerceList listToValue globalSection;
            sections = maybeCoerceAllLists listToValue sections;
          }
        );
    };
}
