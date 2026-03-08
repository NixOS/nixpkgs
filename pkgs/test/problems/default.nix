{
  lib,
  nix,
  runCommand,
  removeReferencesTo,
  path,
  gitMinimal,
}:
let
  nixpkgs = lib.cleanSource path;
  unitResult = import ./unit.nix { inherit lib; };
in
assert lib.assertMsg (unitResult == [ ])
  "problems/unit.nix failing: ${lib.generators.toPretty { } unitResult}";
lib.mapAttrs (
  name: _:
  let
    nixFile = "${./cases + "/${name}/default.nix"}";
    result = runCommand "test-problems-${name}" { nativeBuildInputs = [ removeReferencesTo ]; } ''
      export NIX_STATE_DIR=$(mktemp -d)
      mkdir $out

      command=(
        # FIXME: Using this version because it doesn't print a trace by default
        # Probably should have some regex-style error matching instead
        "${lib.getBin nix}/bin/nix-instantiate"
        ${nixFile}
        # Readonly mode because we don't need to write anything to the store
        "--readonly-mode"
        "--arg"
        "nixpkgs"
        "${nixpkgs}"
      )

      echo "''${command[*]@Q}" > $out/command
      echo "Running ''${command[*]@Q}"
      set +e
      "''${command[@]}" >$out/stdout 2>$out/stderr
      set +e
      echo "$?" > $out/code
      echo "Command exited with code $(<$out/code)"
      remove-references-to -t ${nixFile} $out/stderr
      if grep '(stack trace truncated.*)' $out/stderr; then
        sed -i -n '/(stack trace truncated.*)/,$ p' $out/stderr
      fi
      sed -i 's/^       //' $out/stderr
    '';
    checker = runCommand "test-problems-check-${name}" { } ''
      if ! PAGER=cat ${lib.getExe gitMinimal} diff --no-index ${
        ./cases + "/${name}/expected-stderr"
      } ${result}/stderr ; then
        echo "Output of $(< ${result}/command) does not match what was expected. To adapt:"
        echo "cp ${result}/stderr ${lib.path.removePrefix path ./cases + "/${name}/expected-stderr"}"
        exit 1
      fi
      touch $out
    '';
  in
  checker
) (builtins.readDir ./cases)
