{
  lib,
  pkgs,
}:

{
  format =
    { }:
    {
      type = lib.types.json;

      generate =
        name: value:
        pkgs.callPackage (
          { runCommand, jq }:
          runCommand name
            {
              nativeBuildInputs = [ jq ];
              inherit value;
              preferLocalBuild = true;
              __structuredAttrs = true;
            }
            # NIX_ATTRS_JSON_FILE won't have `value` if it's null, but jq returns null for missing properties anyway
            # jsonNull test keeps this in check
            ''
              jq .value "$NIX_ATTRS_JSON_FILE" > $out
            ''
        ) { };
    };
}
