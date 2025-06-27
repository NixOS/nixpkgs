{
  lib,
  pkgs,
}:

let
  inherit (pkgs.testers) testEqualArrayOrMap;
  inherit (lib.asserts) assertMsg;
  jq = lib.getExe pkgs.jq;
  script = ''
    mkdir -p $out
    nixLog "Running nix-meta hook"
    writeMetaInAllOutputs
    declare -ig writeMetaJSONInstalled=1

    nixLog "$(cat $out/nix-support/meta.json)"
    for value in "''${valuesArray[@]}"; do
      nixLog "Testing jq query '$value'"
      actualArray+=( "$(${jq} -cr "$value" $out/nix-support/meta.json)" )
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
        ".maintainers"
        "keys[]"
      ];
      expectedArray = [
        ''["custom_value"]''
        "maintainers"
      ];
      inherit script;
    }).overrideAttrs
      {
        # Preserve custom_field
        preserveMetaFields = [
          "maintainers"
        ];
        meta.maintainers = [ "custom_value" ];
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

  test_string_context =
  let
    test = builtins.tryEval
      ((pkgs.runCommand "test" {} '''').overrideAttrs { meta.vendor = lib.getExe pkgs.jq; });
  in
    assert assertMsg (test.value == false) "test_string_context should not eval successfully.";
    builtins.toFile "test_string_context" (toString test.value);


  # Test derivation without pname or name?
}
