{
  lib,
  pkgs,
  stdenvNoCC,
}:

let
  tests = tests-stdenv // test-extendMkDerivation // tests-fetchhg // tests-go // tests-python;

  tests-stdenv =
    let
      addEntangled =
        origOverrideAttrs: f:
        origOverrideAttrs (
          lib.composeExtensions f (
            self: super: {
              passthru = super.passthru // {
                entangled = super.passthru.entangled.overrideAttrs f;
                overrideAttrs = addEntangled self.overrideAttrs;
              };
            }
          )
        );

      entangle =
        pkg1: pkg2:
        pkg1.overrideAttrs (
          self: super: {
            passthru = super.passthru // {
              entangled = pkg2;
              overrideAttrs = addEntangled self.overrideAttrs;
            };
          }
        );

      example = entangle pkgs.hello pkgs.figlet;

      overrides1 = example.overrideAttrs (_: super: { pname = "a-better-${super.pname}"; });

      repeatedOverrides = overrides1.overrideAttrs (
        _: super: { pname = "${super.pname}-with-blackjack"; }
      );
    in
    {
      repeatedOverrides-pname = {
        expr = repeatedOverrides.pname;
        expected = "a-better-hello-with-blackjack";
      };
      repeatedOverrides-entangled-pname = {
        expr = repeatedOverrides.entangled.pname;
        expected = "a-better-figlet-with-blackjack";
      };
      overriding-using-only-attrset = {
        expr = (pkgs.hello.overrideAttrs { pname = "hello-overriden"; }).pname;
        expected = "hello-overriden";
      };
      overriding-using-only-attrset-no-final-attrs = {
        name = "overriding-using-only-attrset-no-final-attrs";
        expr =
          ((stdenvNoCC.mkDerivation { pname = "hello-no-final-attrs"; }).overrideAttrs {
            pname = "hello-no-final-attrs-overridden";
          }).pname;
        expected = "hello-no-final-attrs-overridden";
      };
      structuredAttrs-allowedRequisites-nullablility = {
        expr =
          lib.hasPrefix builtins.storeDir
            (pkgs.stdenv.mkDerivation {
              __structuredAttrs = true;
              inherit (pkgs.hello) pname version src;
              allowedRequisites = null;
            }).drvPath;
        expected = true;
      };
    };

  test-extendMkDerivation =
    let
      mkLocalDerivation = lib.extendMkDerivation {
        constructDrv = pkgs.stdenv.mkDerivation;
        excludeDrvArgNames = [
          "specialArg"
        ];
        extendDrvArgs =
          finalAttrs:
          {
            preferLocalBuild ? true,
            allowSubstitute ? false,
            specialArg ? (_: false),
            ...
          }@args:
          {
            inherit preferLocalBuild allowSubstitute;
            passthru = args.passthru or { } // {
              greeting = if specialArg "Hi!" then "Hi!" else "Hello!";
            };
          };
      };

      helloLocalPlainAttrs = {
        inherit (pkgs.hello) pname version src;
        specialArg = throw "specialArg is broken.";
      };

      helloLocalPlain = mkLocalDerivation helloLocalPlainAttrs;

      helloLocal = mkLocalDerivation (
        finalAttrs:
        helloLocalPlainAttrs
        // {
          passthru = pkgs.hello.passthru or { } // {
            foo = "a";
            bar = "${finalAttrs.passthru.foo}b";
          };
        }
      );

      hiLocal = mkLocalDerivation (
        helloLocalPlainAttrs
        // {
          specialArg = s: lib.stringLength s == 3;
        }
      );
    in
    {
      extendMkDerivation-helloLocal-imp-arguments = {
        expr = helloLocal.preferLocalBuild;
        expected = true;
      };
      extendMkDerivation-helloLocal-plain-equivalence = {
        expr = helloLocal.drvPath;
        expected = helloLocalPlain.drvPath;
      };
      extendMkDerivation-helloLocal-finalAttrs = {
        expr = helloLocal.bar;
        expected = "ab";
      };
      extendMkDerivation-helloLocal-specialArg = {
        expr = hiLocal.greeting;
        expected = "Hi!";
      };
    };

  tests-fetchhg =
    let
      ruamel_0_18_14-hash = "sha256-HDkPPp1xI3uoGYlS9mwPp1ZjG2gKvx6vog0Blj6tBuI=";
      ruamel_0_18_14-src = pkgs.fetchhg {
        url = "http://hg.code.sf.net/p/ruamel-yaml/code";
        rev = "0.18.14";
        hash = ruamel_0_18_14-hash;
      };
      ruamel_0_17_21-hash = "sha256-6PV0NyPQfd+4RBqoj5vJaOHShx+TJVHD2IamRinU0VU=";
      ruamel_0_17_21-src = pkgs.fetchhg {
        url = "http://hg.code.sf.net/p/ruamel-yaml/code";
        rev = "0.17.21";
        hash = ruamel_0_17_21-hash;
      };
      ruamel_0_17_21-src-by-overriding = ruamel_0_18_14-src.overrideAttrs {
        rev = "0.17.21";
        hash = ruamel_0_17_21-hash;
      };
    in
    {
      hash-outputHash-equivalence = {
        expr = ruamel_0_17_21-src.outputHash;
        expected = ruamel_0_17_21-hash;
      };

      hash-overridability-outputHash = {
        expr = ruamel_0_17_21-src-by-overriding.outputHash;
        expected = ruamel_0_17_21-hash;
      };

      hash-overridability-drvPath = {
        expr = [
          (lib.isString ruamel_0_17_21-src-by-overriding.drvPath)
          ruamel_0_17_21-src-by-overriding.drvPath
        ];
        expected = [
          true
          ruamel_0_17_21-src.drvPath
        ];
      };

      hash-overridability-outPath = {
        expr = [
          (lib.isString ruamel_0_17_21-src-by-overriding.outPath)
          ruamel_0_17_21-src-by-overriding.outPath
        ];
        expected = [
          true
          ruamel_0_17_21-src.outPath
        ];
      };
    };

  tests-go =
    let
      pet_0_3_4 = pkgs.buildGoModule rec {
        pname = "pet";
        version = "0.3.4";

        src = pkgs.fetchFromGitHub {
          owner = "knqyf263";
          repo = "pet";
          rev = "v${version}";
          hash = "sha256-Gjw1dRrgM8D3G7v6WIM2+50r4HmTXvx0Xxme2fH9TlQ=";
        };

        vendorHash = "sha256-ciBIR+a1oaYH+H1PcC8cD8ncfJczk1IiJ8iYNM+R6aA=";

        meta = {
          description = "Simple command-line snippet manager, written in Go";
          homepage = "https://github.com/knqyf263/pet";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ kalbasit ];
        };
      };

      pet_0_4_0 = pkgs.buildGoModule rec {
        pname = "pet";
        version = "0.4.0";

        src = pkgs.fetchFromGitHub {
          owner = "knqyf263";
          repo = "pet";
          rev = "v${version}";
          hash = "sha256-gVTpzmXekQxGMucDKskGi+e+34nJwwsXwvQTjRO6Gdg=";
        };

        vendorHash = "sha256-dUvp7FEW09V0xMuhewPGw3TuAic/sD7xyXEYviZ2Ivs=";

        meta = {
          description = "Simple command-line snippet manager, written in Go";
          homepage = "https://github.com/knqyf263/pet";
          license = lib.licenses.mit;
          maintainers = with lib.maintainers; [ kalbasit ];
        };
      };

      pet_0_4_0-overridden = pet_0_3_4.overrideAttrs (
        finalAttrs: previousAttrs: {
          version = "0.4.0";

          src = pkgs.fetchFromGitHub {
            inherit (previousAttrs.src) owner repo;
            rev = "v${finalAttrs.version}";
            hash = "sha256-gVTpzmXekQxGMucDKskGi+e+34nJwwsXwvQTjRO6Gdg=";
          };

          vendorHash = "sha256-dUvp7FEW09V0xMuhewPGw3TuAic/sD7xyXEYviZ2Ivs=";
        }
      );

      pet-foo = pet_0_3_4.overrideAttrs (
        finalAttrs: previousAttrs: {
          passthru = previousAttrs.passthru // {
            overrideModAttrs = lib.composeExtensions previousAttrs.passthru.overrideModAttrs (
              finalModAttrs: previousModAttrs: {
                FOO = "foo";
              }
            );
          };
        }
      );

      pet-vendored = pet-foo.overrideAttrs { vendorHash = null; };
    in
    {
      buildGoModule-overrideAttrs =
        let
          getComparingAttrs = p: {
            inherit (p)
              drvPath
              name
              pname
              version
              vendorHash
              ;
            goModules = {
              inherit (p.goModules)
                drvPath
                name
                outPath
                ;
            };
          };
        in
        {
          expr = getComparingAttrs pet_0_4_0-overridden;
          expected = getComparingAttrs pet_0_4_0;
        };
      buildGoModule-goModules-overrideAttrs = {
        expr = pet-foo.goModules.FOO;
        expected = "foo";
      };
      buildGoModule-goModules-overrideAttrs-vendored = {
        expr = lib.isString pet-vendored.drvPath;
        expected = true;
      };
    };

  tests-python =
    let
      p = pkgs.python3Packages.xpybutil.overridePythonAttrs (_: {
        dontWrapPythonPrograms = true;
      });
    in
    {
      overridePythonAttrs = {
        expr = !lib.hasInfix "wrapPythonPrograms" p.postFixup;
        expected = true;
      };
    };

in

stdenvNoCC.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  name = "test-overriding";
  passthru = {
    inherit tests;
    failures = lib.runTests (finalAttrs.passthru.tests // { tests = lib.attrNames tests; });
  };
  testResults = lib.mapAttrs (testName: test: test.expr == test.expected) finalAttrs.passthru.tests;
  buildCommand = ''
    touch $out
    for testName in "''${!testResults[@]}"; do
      if [[ -n "''${testResults[$testName]}" ]]; then
        echo "$testName success"
      else
        echo "$testName fail"
      fi
    done
  ''
  + lib.optionalString (lib.any (v: !v) (lib.attrValues finalAttrs.testResults)) ''
    {
      echo "ERROR: tests.overriding: Encountering failed tests."
      for testName in "''${!testResults[@]}"; do
        if [[ -z "''${testResults[$testName]}" ]]; then
          echo "- $testName"
        fi
      done
      echo "To inspect the expected and actual result, "
      echo '  evaluate `tests.overriding.tests.''${testName}`.'
    } >&2
    exit 1
  '';
})
