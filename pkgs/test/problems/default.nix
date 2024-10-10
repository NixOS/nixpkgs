{
  lib,
  nixVersions,
  runCommand,
  removeReferencesTo,
  path,
}:
let
  nixpkgs = lib.cleanSource path;
in
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
        "${lib.getBin nixVersions.minimum}/bin/nix-instantiate"
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
      "''${command[@]}" > >(tee $out/stdout) 2> >(tee $out/stderr)
      set +e
      echo "$?" > $out/code
      echo "Command exited with code $(<$out/code)"
      remove-references-to -t ${nixFile} $out/*
    '';
    checker = runCommand "test-problems-check-${name}" { } ''
      if ! diff ${result}/stderr ${./cases + "/${name}/expected-stderr"}; then
        echo "Output of $(< ${result}/command) does not match what was expected (${result}/stderr)"
        exit 1
      fi
      touch $out
    '';
  in
  lib.nameValuePair name checker
) (builtins.readDir ./cases)
