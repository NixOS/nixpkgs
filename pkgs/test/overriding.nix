{ lib, pkgs, stdenvNoCC }:

let
  tests =
    let
      p = pkgs.python3Packages.xpybutil.overridePythonAttrs (_: { dontWrapPythonPrograms = true; });
    in
    [
      ({
        name = "overridePythonAttrs";
        expr = !lib.hasInfix "wrapPythonPrograms" p.postFixup;
        expected = true;
      })
      ({
        name = "repeatedOverrides-pname";
        expr = repeatedOverrides.pname == "a-better-hello-with-blackjack";
        expected = true;
      })
      ({
        name = "repeatedOverrides-entangled-pname";
        expr = repeatedOverrides.entangled.pname == "a-better-figlet-with-blackjack";
        expected = true;
      })
      ({
        name = "overriding-using-only-attrset";
        expr = (pkgs.hello.overrideAttrs { pname = "hello-overriden"; }).pname == "hello-overriden";
        expected = true;
      })
      ({
        name = "overriding-using-only-attrset-no-final-attrs";
        expr = ((stdenvNoCC.mkDerivation { pname = "hello-no-final-attrs"; }).overrideAttrs { pname = "hello-no-final-attrs-overridden"; }).pname == "hello-no-final-attrs-overridden";
        expected = true;
      })
      ({
        name = "extendDerivation-passthru";
        expr = helloWithAns0.ans == 42;
        expected = true;
      })
      ({
        name = "extendDerivation-multi-passthru";
        expr = helloMultiWithAns0.man.ans == 42;
        expected = true;
      })
      ({
        name = "extendDerivation'-noKeepOverridable-passthru";
        expr = helloWithAns1.ans == 42;
        expected = true;
      })
      ({
        name = "extendDerivation'-noKeepOverridable-multi-passthru";
        expr = helloMultiWithAns1.man.ans == 42;
        expected = true;
      })
      ({
        name = "extendDerivation'-passthru";
        expr = helloWithAns2.ans == 42;
        expected = true;
      })
      ({
        name = "extendDerivation'-multi-overrideAttrs";
        expr = (helloMultiWithAns2.man.overrideAttrs { }).outputName == "man";
        expected = true;
      })
      ({
        name = "extendDerivation'-overrideAttrs-passthru";
        expr = (helloWithAns2.overrideAttrs { }).ans == 42;
        expected = true;
      })
      ({
        name = "extendDerivation'-overrideDerivation-passthru";
        expr = (helloWithAns2.overrideDerivation (_: { })).ans == 42;
        expected = true;
      })
      ({
        name = "extendDerivation'-override-passthru";
        expr = (helloWithAns2.override { }).ans == 42;
        expected = true;
      })
      ({
        name = "extendDerivation'-multi-overrideAttrs-passthru";
        expr = (helloMultiWithAns2.overrideAttrs { }).man.ans == 42;
        expected = true;
      })
      ({
        name = "extendDerivation'-multi-on-output-overrideAttrs-outputName";
        expr = (helloMultiWithAns2.man.overrideAttrs { }).outputName == "man";
        expected = true;
      })
      ({
        name = "extendDerivation'-multi-on-output-overrideAttrs-passthru";
        expr = (helloMultiWithAns2.man.overrideAttrs { }).ans == 42;
        expected = true;
      })
      ({
        name = "extendDerivation'-spreadOverriders-multi-on-output-override-outputName";
        expr = (helloMultiWithAns3.man.override { }).outputName == "man";
        expected = true;
      })
      ({
        name = "extendDerivation'-spreadOverriders-multi-on-output-override-passthru";
        expr = (helloMultiWithAns3.man.override { }).ans == 42;
        expected = true;
      })
    ]
    ;

  addEntangled = origOverrideAttrs: f:
    origOverrideAttrs (
      lib.composeExtensions f (self: super: {
        passthru = super.passthru // {
          entangled = super.passthru.entangled.overrideAttrs f;
          overrideAttrs = addEntangled self.overrideAttrs;
        };
      })
    );

  entangle = pkg1: pkg2: pkg1.overrideAttrs (self: super: {
    passthru = super.passthru // {
      entangled = pkg2;
      overrideAttrs = addEntangled self.overrideAttrs;
    };
  });

  example = entangle pkgs.hello pkgs.figlet;

  overrides1 = example.overrideAttrs (_: super: { pname = "a-better-${super.pname}"; });

  repeatedOverrides = overrides1.overrideAttrs (_: super: { pname = "${super.pname}-with-blackjack"; });

  helloWithAns0 = lib.extendDerivation true { ans = 42; } pkgs.hello;

  helloWithAns1 = lib.extendDerivation' {
    keepOverriders = false;
    passthru = { ans = 42; };
  } pkgs.hello;

  helloWithAns2 = lib.extendDerivation' {
    passthru = { ans = 42; };
  } pkgs.hello;

  helloMulti = pkgs.hello.overrideAttrs {
    outputs = [ "out" "info" "man" ];
  };

  helloMultiWithAns0 = lib.extendDerivation true { ans = 42; } helloMulti;

  helloMultiWithAns1 = lib.extendDerivation' {
    keepOverriders = false;
    passthru = { ans = 42; };
  } helloMulti;

  helloMultiWithAns2 = lib.extendDerivation' {
    passthru = { ans = 42; };
  } helloMulti;

  helloMultiWithAns3 = lib.extendDerivation' {
    spreadOverriders = true;
    passthru = { ans = 42; };
  } helloMulti;

in

stdenvNoCC.mkDerivation {
  name = "test-overriding";
  passthru = { inherit tests; };
  buildCommand = ''
    touch $out
  '' + lib.concatMapStringsSep "\n" (t: "([[ ${lib.boolToString t.expr} == ${lib.boolToString t.expected} ]] && echo ${lib.escapeShellArg t.name}' success') || (echo ${lib.escapeShellArg t.name}' fail' && exit 1)") tests;
}
