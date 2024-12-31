{ formats, stdenvNoCC, ... }:
let
  hocon = formats.hocon { };

  expression = {
    substitution = { __hocon_envvar = "PATH"; };
    literal = {
      __hocon_unquoted_string = ''
        [
          1,
          "a",
        ]'';
    };

    nested = {
      substitution = { __hocon_envvar = "PATH"; };
      literal = {
        __hocon_unquoted_string = ''
          [
            1,
            "a",
          ]'';
      };
    };

    nested_in_array = [
      { __hocon_envvar = "PATH"; }
      {
        __hocon_unquoted_string = ''
          [
            1,
            "a",
          ]'';
      }
    ];
  };

  hocon-test-conf = hocon.generate "hocon-test.conf" expression;
in
  stdenvNoCC.mkDerivation {
    name = "pkgs.formats.hocon-test-backwards-compatibility";

    dontUnpack = true;
    dontBuild = true;

    doCheck = true;
    checkPhase = ''
      runHook preCheck

      diff -U3 ${./expected.txt} ${hocon-test-conf}

      runHook postCheck
    '';

    installPhase = ''
      runHook preInstall

      mkdir $out
      cp ${./expected.txt} $out/expected.txt
      cp ${hocon-test-conf} $out/hocon-test.conf
      cp ${hocon-test-conf.passthru.json} $out/hocon-test.json

      runHook postInstall
    '';
  }
