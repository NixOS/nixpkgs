{
  lib,
  pkgs,
}:

let
  inherit (pkgs.testers) testEqualArrayOrMap;
  jq = lib.getExe pkgs.jq;
  script = ''
    mkdir -p $out
    nixLog "Running nix-meta hook"
    writeMetaInAllOutputs
    declare -ig writeMetaJSONInstalled=1

    nixLog "$(cat $out/nix-support/meta.json)"
    for value in "''${valuesArray[@]}"; do
      nixLog "Testing jq query '$value'"
      actualArray+=( "$(${jq} -r "$value" $out/nix-support/meta.json)" )
    done
    nixLog "Done"
  '';
in
{
  test_nested_meta =
    (testEqualArrayOrMap {
      name = "temp_name";
      #valuesArray contains jq queries
      valuesArray = [
        ".name"
        ".version"
        ".cpe.key"
        "keys[]"
      ];
      expectedArray = [
        "temp_name"
        "test_version"
        "nested_value"
        "cpe\nname\npname\nversion"
      ];
      inherit script;
    }).overrideAttrs
      {
        pname = "test_pname";
        version = "test_version";
        meta = {
          cpe = {
            key = "nested_value";
          };
        };
      };

  test_custom_field =
    (testEqualArrayOrMap {
      name = "test_custom_field";
      valuesArray = [
        ".custom_field"
        "keys[]"
      ];
      expectedArray = [
        "custom_value"
        "custom_field"
      ];
      inherit script;
    }).overrideAttrs
      {
        # Preserve custom_field
        preserveMetaFields = [
          "custom_field"
        ];
        meta.custom_field = "custom_value";
      };

  test_removed_meta =
    (testEqualArrayOrMap {
      name = "test_removed_meta";
      valuesArray = [
        "$out"
        "$out/nix-support"
        "$out/nix-support/meta.json"
      ];
      expectedArray = [
        "true"
        "false"
        "false"
      ];
      script = ''
        mkdir -p $out
        nixLog "Running nix-meta hook"
        writeMetaInAllOutputs
        declare -ig writeMetaJSONInstalled=1

        for value in "''${valuesArray[@]}"; do
          value="''${value/\$out/$out}"
          nixLog "Testing path '$value'"
          if [[ -e "$value" ]]; then
            actualArray+=( "true" )
          else
            actualArray+=( "false" )
          fi
        done
      '';
    }).overrideAttrs
      {
        # Remove all fields.
        preserveMetaFields = [ ];
      };

}
