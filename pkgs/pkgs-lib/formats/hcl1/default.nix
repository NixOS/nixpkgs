{
  pkgs,
  lib,
  json,
}:
let
  inherit (lib)
    isAttrs
    isDerivation
    mapAttrs
    isList
    ;
in
{
  format =
    let
      # Helper function to recursively transform values for HCL1 canonicalization
      # Rule: If an attribute value is an attribute set, wrap it in a list
      transform =
        value:
        if isAttrs value && !isDerivation value then
          # If it's an attribute set, transform it recursively and wrap in a list
          [ (mapAttrs (name: transform) value) ]
        else if isList value then
          # If it's already a list, transform each element
          map transform value
        else
          value;
      jsonFormat = json { };
    in
    args:
    jsonFormat
    // {
      generate = name: value: jsonFormat.generate name (mapAttrs (_: transform) value);
    };
}
