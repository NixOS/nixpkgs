{ lib, pkgs, stdenvNoCC }:

let
  tests =
    {
      repeatedOverrides-pname = {
        expr = repeatedOverrides.pname == "a-better-hello-with-blackjack";
        expected = true;
      };
      repeatedOverrides-entangled-pname = {
        expr = repeatedOverrides.entangled.pname == "a-better-figlet-with-blackjack";
        expected = true;
      };
      overriding-using-only-attrset = {
        expr = (pkgs.hello.overrideAttrs { pname = "hello-overriden"; }).pname == "hello-overriden";
        expected = true;
      };
      overriding-using-only-attrset-no-final-attrs = {
        name = "overriding-using-only-attrset-no-final-attrs";
        expr = ((stdenvNoCC.mkDerivation { pname = "hello-no-final-attrs"; }).overrideAttrs { pname = "hello-no-final-attrs-overridden"; }).pname == "hello-no-final-attrs-overridden";
        expected = true;
      };

      # Python

      overridePythonAttrs = {
        expr = checkOverridePythonAttrs pipOverridden1;
        expected = true;
      };
      overridePythonAttrs-nested = {
        expr = revertOverridePythonAttrs pipOverridden1 == pip;
        expected = true;
      };
      override-pythonPackage = {
        expr = checkOverrideSetuptools pipOverridden2;
        expected = true;
      };
      override-overridePythonAttrs-test-override = {
        expr = checkOverrideSetuptools pipOverridden3;
        expected = true;
      };
      override-overridePythonAttrs-test-overridePythonAttrs = {
        expr = checkOverridePythonAttrs pipOverridden3;
        expected = true;
      };
    };

  addEntangled = origOverrideAttrs: f:
    origOverrideAttrs (
      lib.composeExtensions f (self: super: {
        passthru = super.passthru // {
          entangled = super.passthru.entangled.overrideAttrs f;
          overrideAttrs = addEntangled self.overrideAttrs;
        };
      })
    );

  # We are testing the overriding result of these packages without building them.
  pkgsAllowingBroken = pkgs.extend (finalAttrs: previousAttrs: {
    config = previousAttrs.config // { allowBroken = true; };
  });

  entangle = pkg1: pkg2: pkg1.overrideAttrs (self: super: {
    passthru = super.passthru // {
      entangled = pkg2;
      overrideAttrs = addEntangled self.overrideAttrs;
    };
  });

  example = entangle pkgs.hello pkgs.figlet;

  overrides1 = example.overrideAttrs (_: super: { pname = "a-better-${super.pname}"; });

  repeatedOverrides = overrides1.overrideAttrs (_: super: { pname = "${super.pname}-with-blackjack"; });


  # Python

  inherit (pkgsAllowingBroken.python3Packages) setuptools pip;
  applyOverridePythonAttrs = p: p.overridePythonAttrs (_: { dontWrapPythonPrograms = true; });
  revertOverridePythonAttrs = p: p.overridePythonAttrs (_: { dontWrapPythonPrograms = false; });
  checkOverridePythonAttrs = p: !lib.hasInfix "wrapPythonPrograms" p.postFixup;
  pipOverridden1 = applyOverridePythonAttrs pip;
  setuptoolsOverridden1 = applyOverridePythonAttrs setuptools;
  applyOverrideSetuptools = p: p.override { setuptools = setuptoolsOverridden1; };
  checkOverrideSetuptools = p: builtins.any (p': lib.hasInfix "setuptools" p'.name && checkOverridePythonAttrs p') p.nativeBuildInputs;
  pipOverridden2 = applyOverrideSetuptools pip;
  # Test ".override .overridePythonAttrs" only, since ".overridePythonAttrs .override" is known to be break.
  pipOverridden3 = applyOverridePythonAttrs pipOverridden2;
in

stdenvNoCC.mkDerivation {
  name = "test-overriding";
  passthru = { inherit tests; };
  buildCommand = ''
    touch $out
  '' + lib.concatStringsSep "\n" (lib.attrValues (lib.mapAttrs (name: t: "([[ ${lib.boolToString t.expr} == ${lib.boolToString t.expected} ]] && echo '${name} success') || (echo '${name} fail' && exit 1)") tests));
}
