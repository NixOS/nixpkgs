{
  pkgs,
  lib,
}:
let
  inherit (lib.types)
    nullOr
    oneOf
    bool
    int
    float
    str
    path
    attrsOf
    listOf
    ;
  inherit (lib.generators)
    toPlist
    ;
in
{
  format =
    {
      escape ? true,
    }:
    {
      type =
        let
          valueType =
            nullOr (oneOf [
              bool
              int
              float
              str
              path
              (attrsOf valueType)
              (listOf valueType)
            ])
            // {
              description = "Property list (plist) value";
            };
        in
        valueType;

      generate = name: value: pkgs.writeText name (toPlist { inherit escape; } value);
    };
}
