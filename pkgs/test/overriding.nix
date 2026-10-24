{
  lib,
  pkgs,
  stdenvNoCC,
  testers,
}:

let
  tests =
    tests-stdenv
    // test-extendMkDerivation
    // tests-fetchgit
    // tests-fetchhg
    // tests-fetchurl
    // tests-go
    // tests-python;

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
      structuredAttrs-allowedRequisites-nullability = {
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

  /**
    Take two positional arguments `fakeHash` and `partialHash`,
    and return a modified version of fakeHash whose hash body is partially substituted by `partialHash` from the beginning,
    used to assert a specific fake hash variant is used by an overridden FOD.

    # Inputs

    `fakeHash`

    : The specified zero fake hash

    `partialHash`

    : A trimmed non-zero hash body, to substitute the beginning of the zero hash body.
  */
  genNonzeroFakeHash =
    fakeHash:
    let
      isSRIHash = lib.hasInfix "-" fakeHash;
      defaultHashAlgo = lib.optionalString isSRIHash lib.head (lib.splitString "-" lib.fakeHash);
      defaultHashPrefix = lib.optionalString isSRIHash (defaultHashAlgo + "-");
      defaultHashBody = lib.removePrefix defaultHashPrefix fakeHash;
    in
    partialHash:
    defaultHashPrefix
    + partialHash
    + (lib.substring (lib.stringLength partialHash) (lib.stringLength defaultHashBody) defaultHashBody);

  tests-fetchgit =
    let
      fakeSha256-1 = genNonzeroFakeHash lib.fakeSha256 "1";
      fakeHash-2 = genNonzeroFakeHash lib.fakeHash "B";
      src-with-sha256 = pkgs.fetchgit {
        url = "https://example.com/source.git";
        sha256 = fakeSha256-1;
      };
    in
    {
      test-fetchgit-hash-compat = {
        expr = {
          inherit (src-with-sha256)
            outputHash
            outputHashAlgo
            ;
        };
        expected = {
          outputHash = fakeSha256-1;
          outputHashAlgo = "sha256";
        };
      };
      test-fetchgit-overrideAttrs-hash = {
        expr = {
          inherit (src-with-sha256.overrideAttrs { hash = fakeHash-2; })
            outputHash
            outputHashAlgo
            ;
        };
        expected = {
          outputHash = fakeHash-2;
          outputHashAlgo = null;
        };
      };
      test-fetchurl-overrideAttrs-hash-empty = {
        expr = {
          inherit (src-with-sha256.overrideAttrs { hash = ""; })
            outputHash
            outputHashAlgo
            ;
        };
        expected = {
          outputHash = lib.fakeHash;
          outputHashAlgo = null;
        };
      };
    };

  tests-fetchurl =
    let
      fakeSha256-1 = genNonzeroFakeHash lib.fakeSha256 "1";
      fakeHash-2 = genNonzeroFakeHash lib.fakeHash "B";
      src-with-sha256 = pkgs.fetchurl {
        url = "https://example.com/source.tar.gz";
        sha256 = fakeSha256-1;
      };
    in
    {
      test-fetchurl-hash-compat = {
        expr = {
          inherit (src-with-sha256)
            outputHash
            outputHashAlgo
            ;
        };
        expected = {
          outputHash = fakeSha256-1;
          outputHashAlgo = "sha256";
        };
      };
      test-fetchurl-overrideAttrs-hash = {
        expr = {
          inherit (src-with-sha256.overrideAttrs { hash = fakeHash-2; })
            outputHash
            outputHashAlgo
            ;
        };
        expected = {
          outputHash = fakeHash-2;
          outputHashAlgo = null;
        };
      };
      test-fetchurl-overrideAttrs-hash-empty = {
        expr = {
          inherit (src-with-sha256.overrideAttrs { hash = ""; })
            outputHash
            outputHashAlgo
            ;
        };
        expected = {
          outputHash = lib.fakeHash;
          outputHashAlgo = null;
        };
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
      package-stub = pkgs.python3Packages.callPackage (
        {
          buildPythonPackage,
          emptyDirectory,
        }:
        buildPythonPackage {
          pname = "python-package-stub";
          version = "0.1.0";
          pyproject = true;
          src = emptyDirectory;
        }
      ) { };

      package-stub-gcc = package-stub.override (previousArgs: {
        buildPythonPackage = previousArgs.buildPythonPackage.override {
          stdenv = pkgs.gccStdenv;
        };
      });
      package-stub-clang = package-stub-gcc.override (previousArgs: {
        buildPythonPackage = previousArgs.buildPythonPackage.override {
          stdenv = pkgs.clangStdenv;
        };
      });
      package-stub-libcxx = package-stub-clang.override (previousArgs: {
        buildPythonPackage = previousArgs.buildPythonPackage.override {
          stdenv = pkgs.libcxxStdenv;
        };
      });

      package-stub-disabled = pkgs.python3Packages.callPackage (
        {
          buildPythonPackage,
          emptyDirectory,
        }:
        buildPythonPackage {
          pname = "python-package-stub";
          version = "0.1.0";
          pyproject = true;
          src = emptyDirectory;
          disabled = true;
        }
      ) { };

      package-stub-disabled-finalAttrs = pkgs.python3Packages.callPackage (
        {
          buildPythonPackage,
          emptyDirectory,
        }:
        buildPythonPackage (finalAttrs: {
          pname = "python-package-stub";
          version = "0.1.0";
          pyproject = true;
          src = emptyDirectory;
          disabled = true;
        })
      ) { };

      package-stub-unsupportedPython = pkgs.python3Packages.callPackage (
        {
          buildPythonPackage,
          emptyDirectory,
        }:
        buildPythonPackage {
          pname = "python-package-stub";
          version = "0.1.0";
          pyproject = true;
          src = emptyDirectory;
          meta.problems.unsupportedPython = { };
        }
      ) { };

      package-stub-unsupportedPython-finalAttrs = pkgs.python3Packages.callPackage (
        {
          buildPythonPackage,
          emptyDirectory,
        }:
        buildPythonPackage (finalAttrs: {
          pname = "python-package-stub";
          version = "0.1.0";
          pyproject = true;
          src = emptyDirectory;
          meta.problems.unsupportedPython = { };
        })
      ) { };

      applyOverridePythonAttrs =
        p:
        p.overridePythonAttrs (previousAttrs: {
          overridePythonAttrsFlag = previousAttrs.overridePythonAttrsFlag or 0 + 1;
        });
      applyOverridePythonAttrsFP =
        p:
        p.overridePythonAttrs (
          finalAttrs: previousAttrs: {
            overridePythonAttrsFlag = previousAttrs.overridePythonAttrsFlag or 0 + 1;
            overridePythonAttrsFlagP1 = finalAttrs.overridePythonAttrsFlag + 1;
          }
        );
      overrideAttrsFooBar =
        drv:
        drv.overrideAttrs (
          finalAttrs: previousAttrs: {
            FOO = "a";
            BAR = finalAttrs.FOO;
          }
        );
    in
    {
      buildPythonPackage-unsupportedPython =
        let
          package-stub = package-stub-unsupportedPython;
        in
        {
          expr = lib.mapAttrs (n: f: f package-stub.meta.problems.unsupportedPython) {
            kind = problems: problems.kind;
            message-non-empty = problems: lib.isString problems.message && problems.message != "";
          };
          expected = {
            kind = "broken";
            message-non-empty = true;
          };
        };
      buildPythonPackage-disabled-to-unsupportedPython =
        let
          package-stub = package-stub-disabled;
        in
        {
          expr = lib.mapAttrs (n: f: f package-stub.meta.problems.unsupportedPython) {
            kind = problem: problem.kind;
            message-non-empty = problem: lib.isString problem.message && problem.message != "";
          };
          expected = {
            kind = "broken";
            message-non-empty = true;
          };
        };

      buildPythonPackage-override-gccStdenv = {
        expr = package-stub-gcc.stdenv;
        expected = pkgs.gccStdenv;
      };
      buildPythonPackage-override-clangStdenv = {
        expr = package-stub-clang.stdenv;
        expected = pkgs.clangStdenv;
      };
      buildPythonPackage-override-libcxxStdenv = {
        expr = package-stub-libcxx.stdenv;
        expected = pkgs.libcxxStdenv;
      };

      overridePythonAttrs = {
        expr = (applyOverridePythonAttrs package-stub).overridePythonAttrsFlag;
        expected = 1;
      };
      overridePythonAttrs-nested = {
        expr = (applyOverridePythonAttrs (applyOverridePythonAttrs package-stub)).overridePythonAttrsFlag;
        expected = 2;
      };
      overridePythonAttrs-plain = {
        expr = (package-stub.overridePythonAttrs { overridePythonAttrsFlag = 0; }).overridePythonAttrsFlag;
        expected = 0;
      };
      overridePythonAttrs-finalAttrs = {
        expr = {
          inherit (applyOverridePythonAttrsFP package-stub)
            overridePythonAttrsFlag
            overridePythonAttrsFlagP1
            ;
        };
        expected = {
          overridePythonAttrsFlag = 1;
          overridePythonAttrsFlagP1 = 2;
        };
      };

      # Even if buildPythonPackage takes `{ disabled = true }` instead of `{ meta.problems.unsupportedPython = { }; }`
      # <pkg>.overridePythonAttrs should still be able to remove attribute `unsupportedPython` from `meta.problems`
      # and remediate the problem.
      overridePythonAttrs-unsupportedPython-remediation =
        let
          packageStubs = {
            unsupportedPython = package-stub-unsupportedPython;
            disabled = package-stub-disabled;
          };
          newArgsCandidates = rec {
            plainFunction =
              previousArgs:
              previousArgs
              // {
                meta = previousArgs.meta or { } // {
                  problems = removeAttrs previousArgs.problems or { } [ "unsupportedPython" ];
                };
              };
            extension = finalAttrs: plainFunction;
          };
        in
        {
          expr = lib.concatMapAttrs (
            packageStubName: package-stub:
            lib.mapAttrs' (newArgsName: newArgs: {
              name = "${packageStubName}-${newArgsName}";
              value = (package-stub.overridePythonAttrs newArgs) ? meta.problems.unsupportedPython;
            }) newArgsCandidates
          ) packageStubs;
          expected = {
            unsupportedPython-plainFunction = false;
            unsupportedPython-extension = false;
            disabled-plainFunction = false;
            disabled-extension = false;
          };
        };

      overridePythonAttrs-deprecated-disabled =
        let
          packageStubs = {
            unsupportedPython = package-stub-unsupportedPython;
            disabled = package-stub-disabled;
          };
          newArgsCandidatesDisabled = rec {
            plainAttrsDisabled = {
              disabled = false;
            };
            plainFunctionDisabled = previousArgs: plainAttrsDisabled;
            extensionDisabled = finalAttrs: plainFunctionDisabled;
          };
          newArgsCandidatesId = {
            plainAttrsId = { };
            plainFunctionDisabled = previousArgs: { };
            extensionDisabled = finalAttrs: previousArgs: { };
          };
          applyOverridingWith =
            newArgsCandidates: packageStubs:
            lib.concatMapAttrs (
              packageStubName: package-stub:
              lib.mapAttrs' (newArgsName: newArgs: {
                name = "${packageStubName}-${newArgsName}";
                value = package-stub.overridePythonAttrs newArgs;
              }) newArgsCandidates
            ) packageStubs;
        in
        {
          expr =
            lib.mapAttrs
              # Whether the problem buildPythonPackage-internal-disabled-overridePythonAttrs is present
              (_: package: package ? meta.problems.buildPythonPackage-internal-disabled-overridePythonAttrs)
              (
                # .overridePythonAttrs { disabled = false; }
                applyOverridingWith newArgsCandidatesDisabled packageStubs
                # Nested overriding.
                // applyOverridingWith newArgsCandidatesDisabled (
                  applyOverridingWith newArgsCandidatesId packageStubs
                )
                // applyOverridingWith newArgsCandidatesId (
                  applyOverridingWith newArgsCandidatesDisabled packageStubs
                )
                // applyOverridingWith newArgsCandidatesDisabled (
                  applyOverridingWith newArgsCandidatesDisabled packageStubs
                )
              );
          expected = lib.genAttrs (lib.crossLists (p: s: p + "-" + s) [
            # { "${packageStudName}-${newArgsCandidateName}" = true; }
            (lib.attrNames packageStubs)
            # { "${packageStudName}-${newArgsCandidateName1}-${newArgsCandidateName2}" = true; }
            (
              (lib.attrNames newArgsCandidatesDisabled)
              ++ (lib.crossLists (p: s: p + "-" + s) [
                (lib.attrNames newArgsCandidatesDisabled)
                (lib.attrNames newArgsCandidatesId)
              ])
              ++ (lib.crossLists (p: s: p + "-" + s) [
                (lib.attrNames newArgsCandidatesId)
                (lib.attrNames newArgsCandidatesDisabled)
              ])
              ++ (lib.crossLists (p: s: p + "-" + s) [
                (lib.attrNames newArgsCandidatesDisabled)
                (lib.attrNames newArgsCandidatesDisabled)
              ])
            )
          ]) (_: true);
        };

      overridePythonAttrs-deprecated-arg-stdenv = {
        expr =
          (package-stub-gcc.overridePythonAttrs {
            stdenv = pkgs.clangStdenv;
          })
            ? meta.problems.buildPythonPackage-internal-stdenv;
        expected = true;
      };

      overrideAttrs-overridePythonAttrs-test-overrideAttrs = {
        expr = {
          inherit (applyOverridePythonAttrs (overrideAttrsFooBar package-stub))
            FOO
            BAR
            ;
        };
        expected = {
          FOO = "a";
          BAR = "a";
        };
      };
      overrideAttrs-overridePythonAttrs-test-overridePythonAttrs = {
        expr = (applyOverridePythonAttrs (overrideAttrsFooBar package-stub)) ? overridePythonAttrsFlag;
        expected = true;
      };
      overrideAttrs-overridePythonAttrs-test-commutation = {
        expr = overrideAttrsFooBar (applyOverridePythonAttrs package-stub);
        expected = applyOverridePythonAttrs (overrideAttrsFooBar package-stub);
      };
      chain-of-overrides = rec {
        expr = lib.pipe package-stub [
          (p: p.overrideAttrs { inherit (expected) a; })
          (p: p.overridePythonAttrs { inherit (expected) b; })
          (p: p.overrideAttrs { inherit (expected) c; })
          (p: p.overridePythonAttrs { inherit (expected) d; })
          (builtins.intersectAttrs expected)
        ];
        expected = lib.genAttrs [ "a" "b" "c" "d" ] lib.id;
      };
    };

in

testers.testEqualEvalSet {
  name = "test-overriding";
  literalPackage = "tests.overriding";
  inherit tests;
}
