{ lib, coreutils, python3, gcc, writeText, writeScript, runCommand, makeBinaryWrapper }:

let
  env = { buildInputs = [ makeBinaryWrapper ]; };
  envCheck = runCommand "envcheck" env ''
    ${gcc}/bin/cc -Wall -Werror -Wpedantic -o $out ${./envcheck.c}
  '';
  makeGoldenTest = testname: runCommand "test-wrapper_${testname}" env ''
    mkdir -p ./tmp/foo

    params=$(<"${./.}/${testname}.cmdline")
    eval "makeCWrapper /send/me/flags $params" > wrapper.c

    diff wrapper.c "${./.}/${testname}.c"

    if [ -f "${./.}/${testname}.env" ]; then
      eval "makeWrapper ${envCheck} wrapped $params"
      env -i ./wrapped > env.txt
      sed "s#SUBST_ARGV0#${envCheck}#;s#SUBST_CWD#$PWD#" \
        "${./.}/${testname}.env" > golden-env.txt
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
  tests = let
    names = [
      "add-flags"
      "argv0"
      "basic"
      "chdir"
      "combination"
      "env"
      "inherit-argv0"
      "invalid-env"
      "prefix"
      "suffix"
    ];
    f = name: lib.nameValuePair name (makeGoldenTest name);
  in builtins.listToAttrs (builtins.map f names);
in writeText "make-binary-wrapper-test" ''
  ${lib.concatStringsSep "\n" (lib.mapAttrsToList (_: test: ''
    "${test.name}" "${test}"
  '') tests)}
'' // tests
