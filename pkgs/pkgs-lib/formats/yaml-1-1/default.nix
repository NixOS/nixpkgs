{
  lib,
  pkgs,
}:

{
  format =
    {
      tags ? false,
    }:
    {
      generate =
        name: value:
        pkgs.callPackage (
          { runCommand, remarshal }:
          runCommand name
            {
              nativeBuildInputs = [ remarshal ];
              inherit value;
              preferLocalBuild = true;
              __structuredAttrs = true;
            }
            ''
              remarshal --from json --to yaml-1.1${lib.optionalString tags " --yaml-tags"} ${
                # attributes with null values are omitted from the JSON with structured attrs
                # yaml_1_1Null test keeps this in check
                if value == null then ''<(echo "null")'' else ''--unwrap value "$NIX_ATTRS_JSON_FILE"''
              } "$out"
            ''
        ) { };

      type = lib.types.serializableValueWith { typeName = "YAML 1.1"; };
    };
}
