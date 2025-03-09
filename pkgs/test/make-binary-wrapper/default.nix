{
  lib,
  stdenv,
  pkgsCross,
  makeBinaryWrapper,
  writeText,
  runCommand,
  runCommandCC,
}:

let
  env = {
    nativeBuildInputs = [ makeBinaryWrapper ];
  };
  envCheck = runCommandCC "envcheck" env ''
    cc -Wall -Werror -Wpedantic -o $out ${./envcheck.c}
  '';
  makeGoldenTest =
    testname:
    runCommand "make-binary-wrapper-test-${testname}" env ''
      mkdir -p tmp/foo # for the chdir test

      source=${
        lib.fileset.toSource {
          root = ./.;
          fileset = lib.fileset.unions [
            (./. + "/${testname}.cmdline")
            (./. + "/${testname}.c")
            (lib.fileset.maybeMissing (./. + "/${testname}.env"))
          ];
        }
      }

      params=$(<"$source/${testname}.cmdline")
      eval "makeCWrapper /send/me/flags $params" > wrapper.c

      diff wrapper.c "$source/${testname}.c"

      if [ -f "$source/${testname}.env" ]; then
        eval "makeWrapper ${envCheck} wrapped $params"
        env -i ./wrapped > env.txt
        sed "s#SUBST_ARGV0#${envCheck}#;s#SUBST_CWD#$PWD#" \
          "$source/${testname}.env" > golden-env.txt
        if ! diff env.txt golden-env.txt; then
          echo "env/argv should be:"
          cat golden-env.txt
          echo "env/argv output is:"
          cat env.txt
          exit 1
        fi
      else
        # without a golden env, we expect the wrapper compilation to fail
        ! eval "makeWrapper ${envCheck} wrapped $params" &> error.txt
      fi

      cp wrapper.c $out
    '';
  tests =
    lib.genAttrs [
      "add-flags"
      "argv0"
      "basic"
      "chdir"
      "combination"
      "env"
      "inherit-argv0"
      "invalid-env"
      "overlength-strings"
      "prefix"
      "suffix"
    ] makeGoldenTest
    // lib.optionalAttrs (!stdenv.hostPlatform.isDarwin) {
      cross =
        pkgsCross.${if stdenv.buildPlatform.isAarch64 then "gnu64" else "aarch64-multiplatform"}.callPackage
          ./cross.nix
          { };
    };
in

writeText "make-binary-wrapper-tests" ''
  ${lib.concatStringsSep "\n" (builtins.attrValues tests)}
''
// tests
