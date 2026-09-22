{
  lib,
  pkgs,
}:
let
  inherit (lib)
    id
    isList
    mapAttrs
    singleton
    ;
  inherit (lib.generators)
    toKeyValue
    ;
  inherit (lib.types)
    bool
    coercedTo
    float
    int
    listOf
    nonEmptyListOf
    nullOr
    oneOf
    str
    attrsOf
    ;
in
{
  format =
    {
      # Represents lists as duplicate keys
      listsAsDuplicateKeys ? false,
      # Alternative to listsAsDuplicateKeys, converts list to non-list
      # listToValue :: [Atom] -> Atom
      listToValue ? null,
      ...
    }@args:
    assert listsAsDuplicateKeys -> listToValue == null;
    {

      type =
        let

          singleAtom =
            nullOr (oneOf [
              bool
              int
              float
              str
            ])
            // {
              description = "atom (null, bool, int, float or string)";
            };

          atom =
            if listsAsDuplicateKeys then
              coercedTo singleAtom singleton (listOf singleAtom)
              // {
                description = singleAtom.description + " or a list of them for duplicate keys";
              }
            else if listToValue != null then
              coercedTo singleAtom singleton (nonEmptyListOf singleAtom)
              // {
                description = singleAtom.description + " or a non-empty list of them";
              }
            else
              singleAtom;

        in
        attrsOf atom;

      generate =
        let
          transformValue =
            if listToValue != null then
              mapAttrs (key: val: if isList val then listToValue val else val)
            else
              id;
          finalArgs = removeAttrs args [ "listToValue" ];
        in
        name: value: pkgs.writeText name (toKeyValue finalArgs (transformValue value));
    };
}
