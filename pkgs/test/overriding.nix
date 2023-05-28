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
        name = "extendMkDerivation-helloLocal-imp-arguments";
        expr = helloLocal.preferLocalBuild;
        expected = true;
      })
      ({
        name = "extendMkDerivation-helloLocal-plain-equivalence";
        expr = helloLocal.drvPath == helloLocalPlain.drvPath;
        expected = true;
      })
      ({
        name = "extendMkDerivation-helloLocal-finalAttrs";
        expr = helloLocal.bar == "ab";
        expected = true;
      })
      ({
        name = "extendMkDerivation-helloLocal-finalPackage";
        expr = lib.stringLength helloLocal.passthru.tests.run.outPath > 0;
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

  mkLocalDerivation =
    lib.extendMkDerivation pkgs.stdenv.mkDerivation (finalAttrs:
      { preferLocalBuild ? true
      , allowSubstitute ? false
      , impassablePredicate ? (_: false)
      , ...
      }@args:
      removeAttrs args [ "impassablePredicate" ] // {
        inherit preferLocalBuild allowSubstitute;
      });

  helloLocalPlainAttrs = {
    inherit (pkgs.hello) pname version src;
    impassablePredicate = throw "impassiblePredicate: not implemented";
  };

  helloLocalPlain = mkLocalDerivation helloLocalPlainAttrs;

  helloLocal = mkLocalDerivation (finalAttrs: helloLocalPlainAttrs // {
    passthru = pkgs.hello.passthru or { } // {
      foo = "a";
      bar = "${finalAttrs.passthru.foo}b";
      tests = pkgs.hello.passthru.tests or { } // {
        run = pkgs.runCommandLocal "test-hello-run" {
          nativeBuildInputs = [ finalAttrs.finalPackage ];
        } ''
          set -eu -o pipefail
          RESULT="$(hello | tee "$out")"
          [[ "$RESULT" == "Hello, world!" ]]
        '';
      };
    };
  });
in

stdenvNoCC.mkDerivation {
  name = "test-overriding";
  passthru = { inherit tests; };
  buildCommand = ''
    touch $out
  '' + lib.concatMapStringsSep "\n" (t: "([[ ${lib.boolToString t.expr} == ${lib.boolToString t.expected} ]] && echo '${t.name} success') || (echo '${t.name} fail' && exit 1)") tests;
}
