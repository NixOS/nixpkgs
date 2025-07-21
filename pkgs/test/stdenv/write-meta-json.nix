{
  lib,
  pkgs,
}:

let
  inherit (pkgs.testers) testEqualArrayOrMap;
  inherit (lib.asserts) assertMsg;
  jq = lib.getExe pkgs.jq;
  script = ''
    source ${writeMetaJSON}
    mkdir -p $out
    nixLog "Running nix-meta hook"
    writeMetaInAllOutputs

    nixLog "$(cat $out/nix-support/meta.json)"
    for value in "''${valuesArray[@]}"; do
      nixLog "Testing jq query '$value'"
      actualArray+=( "$(${jq} -cr "$value" $out/nix-support/meta.json)" )
    done
    nixLog "Done"
  '';

  writeMetaJSON = pkgs.writeScript "write-meta-json.sh" ''
    # This setup hook, writes the derivation nixMetaJSON info
    # to $output/nix-support/meta.json so package information
    # can be reconstructed at runtime.


    # Guard against double inclusion.
    if (("''${writeMetaJSONInstalled:-0}" > 0)); then
      nixInfoLog "skipping because the hook has been propagated more than once"
      return 0
    fi
    declare -ig writeMetaJSONInstalled=1


    fixupOutputHooks+=(writeMetaInAllOutputs)

    writeMetaJSON() {
      local -r output="''${1:?}"
      if [[ ! -e $output ]]; then
        nixWarnLog "skipping non-existent output $output"
        return 0
      fi
      if [[ ! -d $output ]]; then
        nixWarnLog "skipping non-directory output $output"
        return 0
      fi
      if [[ -e "$output/nix-support/meta.json" ]]; then
        nixWarnLog "skipping already present meta.json"
        return 0
      fi
      mkdir -p "$output/nix-support"
      echo -n "$nixMetaJSON" >> "$output/nix-support/meta.json"
    }

    writeMetaInAllOutputs() {
      if [[ -z "''${nixMetaJSON:-}" ]]; then
        nixWarnLog "\$nixMetaJSON not present or empty, skipping"
        return 0
      fi
        for output in $(getAllOutputNames); do
          nixInfoLog "Running write-meta-json for $output"
          writeMetaJSON "''${!output}"
        done
    }
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

  test_string_context =
  let
    test = builtins.tryEval
      ((pkgs.runCommand "test" {} '''').overrideAttrs { meta.vendor = lib.getExe pkgs.jq; });
  in
    assert assertMsg (test.value == false) "test_string_context should not eval successfully.";
    builtins.toFile "test_string_context" (toString test.value);
}
