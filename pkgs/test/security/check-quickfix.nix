let
  testDrv = stdenv: name: rec {
      inherit name;
      buildInputs = [ ];
      buildCommand = ''
        mkdir -p $out
        touch $out/installed
        echo ${name} >> $out/installed
        touch $out/dependency
        echo $out >> $out/dependency
      '';

      meta = with stdenv.lib; {
        homepage = https://nixos.org/;
        description = "Test case";
        longDescription = "Test case";
        license = licenses.mit;
        maintainers = [ maintainers.pierron ];
        platforms = platforms.all;
      };
    };

  testDrvWithDep = stdenv: name: dep:
    let drv = testDrv stdenv name; in drv // {
      buildInputs = [ dep ];
      buildCommand = drv.buildCommand + ''
        cat ${dep}/installed >> $out/installed
        cat ${dep}/dependency >> $out/dependency
      '';
    };

  testPkg = stdenv: name:
    stdenv.mkDerivation (testDrv stdenv name);

  testPkgWithDep = stdenv: name: dep:
    stdenv.mkDerivation (testDrvWithDep stdenv name dep);

  pkgTestDead = { stdenv, name ? "dead-1.0.0" }:
    testPkg stdenv name;
  pkgTestBeef = { stdenv, name ? "beef-1.0.0", test-dead }:
    testPkgWithDep stdenv name test-dead;
  pkgTestAte = { stdenv, name ? "ate-1.0.0", test-beef }:
    testPkgWithDep stdenv name test-beef;
  pkgTestBad = { stdenv, name ? "bad-1.0.0", test-ate }:
    testPkgWithDep stdenv name test-ate;
  pkgTestFood = { stdenv, name ? "food-1.0.0", test-bad }:
    testPkgWithDep stdenv name test-bad;

  originalPackages = {
    adapters = import ../../../pkgs/stdenv/adapters.nix;
    builders = import ../../../pkgs/build-support/trivial-builders.nix;
    stdenv = import ../../../pkgs/top-level/stdenv.nix;
    all = import ../../../pkgs/top-level/all-packages.nix;
    aliases = import ../../../pkgs/top-level/aliases.nix;
  };

  defaultPackages = originalPackages // {
    all = top: self: pkgs: originalPackages.all top self pkgs // (
      let callPackage = top.lib.callPackageWith pkgs; in {
        test-dead = callPackage pkgTestDead { };
        test-beef = callPackage pkgTestBeef { };
        test-ate  = callPackage pkgTestAte  { };
        test-bad  = callPackage pkgTestBad  { };
        test-food = callPackage pkgTestFood { };
      });
  };

  # Only change the foo package which is used explicitly by bar, and
  # indirectly by baz.
  quickfixPackages = originalPackages // {
    all = top: self: pkgs: originalPackages.all top self pkgs // (
      let callPackage = top.lib.callPackageWith pkgs; in {
        test-dead = callPackage pkgTestDead { };
        test-beef = callPackage pkgTestBeef { name = "beef-1.0.2"; };
        test-ate  = callPackage pkgTestAte  { };
        test-bad  = callPackage pkgTestBad  { name = "bad-1.0.51"; };
        test-food = callPackage pkgTestFood { };
      });
  };

  withoutFix = import ../../../. {
    inherit defaultPackages;
    quickfixPackages = null;
  };

  withFix = import ../../../. {
    inherit defaultPackages quickfixPackages;
  };
in

  withoutFix.stdenv.mkDerivation {
    name = "check-quickfix";
    buildInputs = [];
    buildCommand = ''
      length() {
        local arg="$1";
        echo ''${#arg};
      }
      set -x;

      : Check that fixes are correctly applies.
      test    ${withoutFix.test-dead} = ${withFix.test-dead}
      test \! ${withoutFix.test-beef} = ${withFix.test-beef} # recompiled
      test \! ${withoutFix.test-ate } = ${withFix.test-ate } # patched
      test \! ${withoutFix.test-bad } = ${withFix.test-bad } # recompiled & patched
      test \! ${withoutFix.test-food} = ${withFix.test-food} # patched

      : Check output paths have identical length.
      test $(length ${withoutFix.test-dead}) -eq $(length ${withFix.test-dead})
      test $(length ${withoutFix.test-beef}) -eq $(length ${withFix.test-beef})
      test $(length ${withoutFix.test-ate }) -eq $(length ${withFix.test-ate })
      test $(length ${withoutFix.test-bad }) -eq $(length ${withFix.test-bad }) # renamed
      test $(length ${withoutFix.test-food}) -eq $(length ${withFix.test-food})

      : Check compiled packages names.
      grep -q "dead-1.0.0" ${withoutFix.test-dead}/installed
      grep -q "beef-1.0.0" ${withoutFix.test-beef}/installed
      grep -q "ate-1.0.0"  ${withoutFix.test-ate }/installed
      grep -q "bad-1.0.0"  ${withoutFix.test-bad }/installed
      grep -q "food-1.0.0" ${withoutFix.test-food}/installed

      grep -q "dead-1.0.0" ${withoutFix.test-beef}/installed
      grep -q "beef-1.0.0" ${withoutFix.test-ate }/installed
      grep -q "ate-1.0.0"  ${withoutFix.test-bad }/installed
      grep -q "bad-1.0.0"  ${withoutFix.test-food}/installed

      grep -q "dead-1.0.0" ${withoutFix.test-ate }/installed
      grep -q "beef-1.0.0" ${withoutFix.test-bad }/installed
      grep -q "ate-1.0.0"  ${withoutFix.test-food}/installed

      grep -q "dead-1.0.0" ${withoutFix.test-bad }/installed
      grep -q "beef-1.0.0" ${withoutFix.test-food}/installed

      grep -q "dead-1.0.0" ${withoutFix.test-food}/installed

      grep -q "dead-1.0.0" ${withFix.test-dead}/installed
      grep -q "beef-1.0.2" ${withFix.test-beef}/installed
      grep -q "ate-1.0.0"  ${withFix.test-ate }/installed
      grep -q "bad-1.0.51" ${withFix.test-bad }/installed # not renamed
      grep -q "food-1.0.0" ${withFix.test-food}/installed

      grep -q "dead-1.0.0" ${withFix.test-beef}/installed
      grep -q "beef-1.0.0" ${withFix.test-ate }/installed # not updated
      grep -q "ate-1.0.0"  ${withFix.test-bad }/installed
      grep -q "bad-1.0.0"  ${withFix.test-food}/installed # not updated

      grep -q "dead-1.0.0" ${withFix.test-ate }/installed
      grep -q "beef-1.0.0" ${withFix.test-bad }/installed # not updated
      grep -q "ate-1.0.0"  ${withFix.test-food}/installed

      grep -q "dead-1.0.0" ${withFix.test-bad }/installed
      grep -q "beef-1.0.0" ${withFix.test-food}/installed # not updated

      grep -q "dead-1.0.0" ${withFix.test-food}/installed

       : Check dependencies hashes.
      grep -q ${withoutFix.test-dead} ${withoutFix.test-dead}/dependency
      grep -q ${withoutFix.test-beef} ${withoutFix.test-beef}/dependency
      grep -q ${withoutFix.test-ate } ${withoutFix.test-ate }/dependency
      grep -q ${withoutFix.test-bad } ${withoutFix.test-bad }/dependency
      grep -q ${withoutFix.test-food} ${withoutFix.test-food}/dependency

      grep -q ${withoutFix.test-dead} ${withoutFix.test-beef}/dependency
      grep -q ${withoutFix.test-beef} ${withoutFix.test-ate }/dependency
      grep -q ${withoutFix.test-ate } ${withoutFix.test-bad }/dependency
      grep -q ${withoutFix.test-bad } ${withoutFix.test-food}/dependency

      grep -q ${withoutFix.test-dead} ${withoutFix.test-ate }/dependency
      grep -q ${withoutFix.test-beef} ${withoutFix.test-bad }/dependency
      grep -q ${withoutFix.test-ate } ${withoutFix.test-food}/dependency

      grep -q ${withoutFix.test-dead} ${withoutFix.test-bad }/dependency
      grep -q ${withoutFix.test-beef} ${withoutFix.test-food}/dependency

      grep -q ${withoutFix.test-dead} ${withoutFix.test-food}/dependency

      grep -q ${withFix.test-dead} ${withFix.test-dead}/dependency
      grep -q ${withFix.test-beef} ${withFix.test-beef}/dependency # recompiled
      grep -q ${withFix.test-ate } ${withFix.test-ate }/dependency
      grep -q ${withFix.test-bad } ${withFix.test-bad }/dependency # recompiled
      grep -q ${withFix.test-food} ${withFix.test-food}/dependency

      grep -q ${withFix.test-dead} ${withFix.test-beef}/dependency
      grep -q ${withFix.test-beef} ${withFix.test-ate }/dependency # patched
      grep -q ${withFix.test-ate } ${withFix.test-bad }/dependency
      grep -q ${withFix.test-bad } ${withFix.test-food}/dependency # patched

      grep -q ${withFix.test-dead} ${withFix.test-ate }/dependency
      grep -q ${withFix.test-beef} ${withFix.test-bad }/dependency # patched
      grep -q ${withFix.test-ate } ${withFix.test-food}/dependency

      grep -q ${withFix.test-dead} ${withFix.test-bad }/dependency
      grep -q ${withFix.test-beef} ${withFix.test-food}/dependency # patched

      grep -q ${withFix.test-dead} ${withFix.test-food}/dependency

      mkdir -p $out
      echo success > $out/result
      set +x
    '';
  }
