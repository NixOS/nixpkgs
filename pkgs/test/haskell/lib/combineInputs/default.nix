{
  lib,
  haskell,
  haskellPackages,
}:

let

  inherit (haskell.lib) combineInputs;

  # An empty result set to save us a bunch of typing for empty lists.
  #
  # NOTE: This doesn't have any `benchmark*` attributes because we don't set
  # `doBenchmark` for most of the test packages.
  emptyResult = {
    buildDepends = [ ];
    buildTools = [ ];
    executableFrameworkDepends = [ ];
    executableHaskellDepends = [ ];
    executablePkgconfigDepends = [ ];
    executableSystemDepends = [ ];
    executableToolDepends = [ ];
    extraLibraries = [ ];
    libraryFrameworkDepends = [ ];
    libraryHaskellDepends = [ ];
    libraryPkgconfigDepends = [ ];
    librarySystemDepends = [ ];
    libraryToolDepends = [ ];
    pkg-configDepends = [ ];
    setupHaskellDepends = [ ];
    testDepends = [ ];
    testFrameworkDepends = [ ];
    testHaskellDepends = [ ];
    testPkgconfigDepends = [ ];
    testSystemDepends = [ ];
    testToolDepends = [ ];
  };

  fakePkg =
    args:
    haskellPackages.mkDerivation (
      {
        version = "0";
        license = lib.licenses.mit;
        src = null;
      }
      // args
    );

  fakeHsPkgs = {
    a = fakePkg {
      pname = "a";
      libraryHaskellDepends = [
        fakeHsPkgs.b
      ];
    };

    b = fakePkg {
      pname = "b";
      libraryHaskellDepends = [
        fakeHsPkgs.d
      ];
    };

    c = fakePkg {
      pname = "c";
      libraryHaskellDepends = [
        fakeHsPkgs.d
      ];
    };

    d = fakePkg {
      pname = "d";
    };

    e = fakePkg {
      pname = "e";
      libraryHaskellDepends = [
        fakeHsPkgs.a
      ];
    };

    # A package with dependencies in all attributes.
    allAttributes = fakePkg {
      pname = "allAttributes";

      doCheck = true;
      doBenchmark = true;

      buildDepends = [ fakeHsPkgs.a ];
      buildTools = [ fakeHsPkgs.a ];
      executableFrameworkDepends = [ fakeHsPkgs.a ];
      executableHaskellDepends = [ fakeHsPkgs.a ];
      executablePkgconfigDepends = [ fakeHsPkgs.a ];
      executableSystemDepends = [ fakeHsPkgs.a ];
      executableToolDepends = [ fakeHsPkgs.a ];
      extraLibraries = [ fakeHsPkgs.a ];
      libraryFrameworkDepends = [ fakeHsPkgs.a ];
      libraryHaskellDepends = [ fakeHsPkgs.a ];
      libraryPkgconfigDepends = [ fakeHsPkgs.a ];
      librarySystemDepends = [ fakeHsPkgs.a ];
      libraryToolDepends = [ fakeHsPkgs.a ];
      pkg-configDepends = [ fakeHsPkgs.a ];
      setupHaskellDepends = [ fakeHsPkgs.a ];
      testDepends = [ fakeHsPkgs.a ];
      testFrameworkDepends = [ fakeHsPkgs.a ];
      testHaskellDepends = [ fakeHsPkgs.a ];
      testPkgconfigDepends = [ fakeHsPkgs.a ];
      testSystemDepends = [ fakeHsPkgs.a ];
      testToolDepends = [ fakeHsPkgs.a ];
      benchmarkDepends = [ fakeHsPkgs.a ];
      benchmarkFrameworkDepends = [ fakeHsPkgs.a ];
      benchmarkHaskellDepends = [ fakeHsPkgs.a ];
      benchmarkPkgconfigDepends = [ fakeHsPkgs.a ];
      benchmarkSystemDepends = [ fakeHsPkgs.a ];
      benchmarkToolDepends = [ fakeHsPkgs.a ];
    };
  };

  failures = lib.runTests {
    testTrivial = {
      expr = combineInputs {
        packages = [ ];
      };
      # Interestingly, this doesn't include any attributes.
      expected = { };
    };

    # We don't pull in transitive dependencies.
    testTransitive = {
      expr = combineInputs {
        packages = [
          fakeHsPkgs.a
        ];
      };
      expected = emptyResult // {
        libraryHaskellDepends = [
          fakeHsPkgs.b
        ];
      };
    };

    # We can ask for multiple packages.
    testMultiple = {
      expr = combineInputs {
        packages = [
          fakeHsPkgs.a
          fakeHsPkgs.c
        ];
      };
      expected = emptyResult // {
        libraryHaskellDepends = [
          fakeHsPkgs.b
          fakeHsPkgs.d
        ];
      };
    };

    # Dependencies which are in the `packages` input list are not returned.
    testExcludeInputs = {
      expr = combineInputs {
        packages = [
          fakeHsPkgs.a
          fakeHsPkgs.e
        ];
      };
      expected = emptyResult // {
        libraryHaskellDepends = [
          fakeHsPkgs.b
        ];
      };
    };

    testAllAttributes = {
      expr = combineInputs {
        packages = [
          fakeHsPkgs.allAttributes
        ];
      };
      expected = {
        buildDepends = [ fakeHsPkgs.a ];
        buildTools = [ fakeHsPkgs.a ];
        executableFrameworkDepends = [ fakeHsPkgs.a ];
        executableHaskellDepends = [ fakeHsPkgs.a ];
        executablePkgconfigDepends = [ fakeHsPkgs.a ];
        executableSystemDepends = [ fakeHsPkgs.a ];
        executableToolDepends = [ fakeHsPkgs.a ];
        extraLibraries = [ fakeHsPkgs.a ];
        libraryFrameworkDepends = [ fakeHsPkgs.a ];
        libraryHaskellDepends = [ fakeHsPkgs.a ];
        libraryPkgconfigDepends = [ fakeHsPkgs.a ];
        librarySystemDepends = [ fakeHsPkgs.a ];
        libraryToolDepends = [ fakeHsPkgs.a ];
        pkg-configDepends = [ fakeHsPkgs.a ];
        setupHaskellDepends = [ fakeHsPkgs.a ];
        testDepends = [ fakeHsPkgs.a ];
        testFrameworkDepends = [ fakeHsPkgs.a ];
        testHaskellDepends = [ fakeHsPkgs.a ];
        testPkgconfigDepends = [ fakeHsPkgs.a ];
        testSystemDepends = [ fakeHsPkgs.a ];
        testToolDepends = [ fakeHsPkgs.a ];
        benchmarkDepends = [ fakeHsPkgs.a ];
        benchmarkFrameworkDepends = [ fakeHsPkgs.a ];
        benchmarkHaskellDepends = [ fakeHsPkgs.a ];
        benchmarkPkgconfigDepends = [ fakeHsPkgs.a ];
        benchmarkSystemDepends = [ fakeHsPkgs.a ];
        benchmarkToolDepends = [ fakeHsPkgs.a ];
      };
    };

    # Packages in `extraDependencies` are returned, but _their_ dependencies are not.
    testExtraDependencies = {
      expr = combineInputs {
        packages = [
          fakeHsPkgs.a
        ];
        extraDependencies = {
          libraryHaskellDepends = [
            fakeHsPkgs.c
          ];
        };
      };
      expected = emptyResult // {
        libraryHaskellDepends = [
          fakeHsPkgs.b
          fakeHsPkgs.c
        ];
      };
    };
  };

in
if failures == [ ] then null else builtins.throw (builtins.toJSON failures)
