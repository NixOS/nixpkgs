{
  pkgs,
  lib,
}:
let
  inherit (lib)
    id
    isList
    pipe
    mapAttrs
    singleton
    ;
  inherit (lib.generators)
    toINI
    ;
  inherit (lib.types)
    attrsOf
    bool
    coercedTo
    either
    float
    int
    listOf
    nonEmptyListOf
    nullOr
    oneOf
    str
    ;

  # the ini formats share a lot of code
  common = rec {
    singleIniAtom =
      nullOr (oneOf [
        bool
        int
        float
        str
      ])
      // {
        description = "INI atom (null, bool, int, float or string)";
      };

    iniAtom =
      {
        listsAsDuplicateKeys,
        listToValue,
        atomsCoercedToLists,
      }:
      let
        singleIniAtomOr =
          if atomsCoercedToLists then coercedTo singleIniAtom singleton else either singleIniAtom;
      in
      if listsAsDuplicateKeys then
        singleIniAtomOr (listOf singleIniAtom)
        // {
          description = singleIniAtom.description + " or a list of them for duplicate keys";
        }
      else if listToValue != null then
        singleIniAtomOr (nonEmptyListOf singleIniAtom)
        // {
          description = singleIniAtom.description + " or a non-empty list of them";
        }
      else
        singleIniAtom;

    iniSection =
      atom:
      attrsOf atom
      // {
        description = "section of an INI file (attrs of " + atom.description + ")";
      };

    maybeCoerceList =
      listToValue:
      if listToValue != null then
        mapAttrs (key: val: if isList val then listToValue val else val)
      else
        id;

    maybeCoerceAllLists =
      listToValue:
      if listToValue != null then
        mapAttrs (_: mapAttrs (key: val: if isList val then listToValue val else val))
      else
        id;

    ignoredArgs = [
      "listToValue"
      "atomsCoercedToLists"
    ];
  };
in
{
  inherit common;

  format =
    let
      inherit (common)
        ignoredArgs
        iniAtom
        iniSection
        maybeCoerceAllLists
        ;
    in
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
      type = attrsOf (iniSection atom);

      lib.types.atom = atom;

      generate =
        name: value:
        pipe value [
          (maybeCoerceAllLists listToValue)
          (toINI (removeAttrs args ignoredArgs))
          (pkgs.writeText name)
        ];
    };
}
