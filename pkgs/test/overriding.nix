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
    ];

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
in

stdenvNoCC.mkDerivation {
  name = "test-overriding";
  passthru = { inherit tests; };
  buildCommand = ''
    touch $out
  '' + lib.concatMapStringsSep "\n" (t: "([[ ${lib.boolToString t.expr} == ${lib.boolToString t.expected} ]] && echo '${t.name} success') || (echo '${t.name} fail' && exit 1)") tests;
}
