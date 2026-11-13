{
  lib,
  pkgs,
  json2x,
}:
{
  format =
    { }:
    {
      type = lib.types.toml;

      generate =
        name: value:
        pkgs.callPackage (
          { runCommand }:
          runCommand name
            {
              nativeBuildInputs = [ json2x ];
              inherit value;
              preferLocalBuild = true;
              __structuredAttrs = true;
            }
            ''
              json2x toml --unwrap value "$NIX_ATTRS_JSON_FILE" "$out"
            ''
        ) { };
    };
}
