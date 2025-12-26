{
  lib,
  haskellPackages,
}:

let
  withEnv =
    env:
    haskellPackages.mkDerivation {
      pname = "puppy";
      version = "1.0.0";
      src = null;
      license = null;

      inherit env;
    };

  failures = lib.runTests {
    testCanSetEnv = {
      expr =
        (withEnv {
          PUPPY = "DOGGY";
        }).drvAttrs.PUPPY;
      expected = "DOGGY";
    };

    testCanSetEnvMultiple = {
      expr =
        let
          env =
            (withEnv {
              PUPPY = "DOGGY";
              SILLY = "GOOFY";
            }).drvAttrs;
        in
        {
          inherit (env) PUPPY SILLY;
        };
      expected = {
        PUPPY = "DOGGY";
        SILLY = "GOOFY";
      };
    };

    testCanSetEnvPassthru = {
      expr =
        (withEnv {
          PUPPY = "DOGGY";
        }).passthru.env.PUPPY;
      expected = "DOGGY";
    };
  };
in
# TODO: Use `lib.debug.throwTestFailures`: https://github.com/NixOS/nixpkgs/pull/416207
lib.optional (failures != [ ]) (throw "${lib.generators.toPretty { } failures}")
