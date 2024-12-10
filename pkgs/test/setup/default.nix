# To run these tests, without bootstrapping:
#
#   nix-build -A tests.setup --arg config "{ baseCommit = ''$(git merge-base HEAD upstream/master)''; }"
#
# Note that `tests.stdenv` currently also contains relevant tests, which are slower, but could be ported here.

{
  # A Nixpkgs which may use the old setup.sh, for which we have binaries in the cache.
  basePkgs
}:

let
  stdenv = basePkgs.stdenv.override {
    # Restore setup.sh, but only for new derivations
    setupScript = ../../stdenv/generic/setup.sh;
  };
  inherit (basePkgs) lib testers;
in
lib.recurseIntoAttrs rec {

  # A manual testing tool.
  # This works for a few packages. Could be developed further, but it's a tarpit.
  # Example:
  #   nix-build -A tests.setup.try-override-shallow.pkgs.hello --arg config "{ baseCommit = ''$(git merge-base HEAD upstream/master)''; }"
  try-override-shallow = {
    # no recurseIntoAttrs!
    pkgs = lib.mapAttrs (name: old:
      let new = old.override { inherit stdenv; };
      in
        assert lib.isDerivation old;
        assert old != new;
        new) basePkgs;
  };

  test-happy = stdenv.mkDerivation {
    name = "hi";
    dontUnpack = true;
    buildPhase = ":";
    installPhase = ''
      mkdir -p $out/bin $out/empty
      echo foo >$out/regular
      echo bar >$out/bin/script
      chmod a+x $out/bin/script
      ln -s ../regular $out/symlink
    '';
    doInstallCheck = true;
  };

  test-installPhase-modified-regular =
    basePkgs.runCommand "test-installPhase-modified-regular" {
      failure = testers.testBuildFailure (
        test-happy.overrideAttrs {
          installCheckPhase = ''
            echo baz >$out/regular
          '';
        }
      );
    } ''
      echo $failure/testBuildFailure.log
      (
        set -x
        grep 'ERROR: Files were changed during installCheckPhase' $failure/testBuildFailure.log >/dev/null
        grep "$failure/regular" $failure/testBuildFailure.log >/dev/null
      )
      touch $out
    '';

  test-installPhase-modified-exe-bit =
    basePkgs.runCommand "test-installPhase-modified-exe-bit" {
      failure = testers.testBuildFailure (
        test-happy.overrideAttrs {
          installCheckPhase = ''
            chmod a-x $out/bin/script
          '';
        }
      );
    } ''
      echo $failure/testBuildFailure.log
      (
        set -x
        grep 'ERROR: Files were changed during installCheckPhase' $failure/testBuildFailure.log >/dev/null
        grep "$failure/bin/script" $failure/testBuildFailure.log >/dev/null
      )
      touch $out
    '';

  test-installPhase-modified-new-file =
    basePkgs.runCommand "test-installPhase-modified-new-file" {
      failure = testers.testBuildFailure (
        test-happy.overrideAttrs {
          installCheckPhase = ''
            echo baz >$out/new
          '';
        }
      );
    } ''
      echo $failure/testBuildFailure.log
      (
        set -x
        grep 'ERROR: Files were changed during installCheckPhase' $failure/testBuildFailure.log >/dev/null
        grep "$failure/new" $failure/testBuildFailure.log >/dev/null
      )
      touch $out
    '';

  test-installPhase-modified-remove-empty-dir =
    basePkgs.runCommand "test-installPhase-modified-remove-empty-dir" {
      failure = testers.testBuildFailure (
        test-happy.overrideAttrs {
          installCheckPhase = ''
            rmdir $out/empty
          '';
        }
      );
    } ''
      echo $failure/testBuildFailure.log
      (
        set -x
        grep 'ERROR: Files were changed during installCheckPhase' $failure/testBuildFailure.log >/dev/null
        grep "$failure/empty" $failure/testBuildFailure.log >/dev/null
      )
      touch $out
    '';

  test-installPhase-modified-remove-regular =
    basePkgs.runCommand "test-installPhase-modified-remove-regular" {
      failure = testers.testBuildFailure (
        test-happy.overrideAttrs {
          installCheckPhase = ''
            rm $out/regular
          '';
        }
      );
    } ''
      echo $failure/testBuildFailure.log
      (
        set -x
        grep 'ERROR: Files were changed during installCheckPhase' $failure/testBuildFailure.log >/dev/null
        grep "$failure/regular" $failure/testBuildFailure.log >/dev/null
      )
      touch $out
    '';

  test-installPhase-modified-remove-symlink =
    basePkgs.runCommand "test-installPhase-modified-remove-symlink" {
      failure = testers.testBuildFailure (
        test-happy.overrideAttrs {
          installCheckPhase = ''
            rm $out/symlink
          '';
        }
      );
    } ''
      echo $failure/testBuildFailure.log
      (
        set -x
        grep 'ERROR: Files were changed during installCheckPhase' $failure/testBuildFailure.log >/dev/null
        grep "$failure/symlink" $failure/testBuildFailure.log >/dev/null
      )
      touch $out
    '';

  test-installPhase-modified-remove-bin =
    basePkgs.runCommand "test-installPhase-modified-remove-bin" {
      failure = testers.testBuildFailure (
        test-happy.overrideAttrs {
          installCheckPhase = ''
            rm $out/bin/script
          '';
        }
      );
    } ''
      echo $failure/testBuildFailure.log
      (
        set -x
        grep 'ERROR: Files were changed during installCheckPhase' $failure/testBuildFailure.log >/dev/null
        grep "$failure/bin/script" $failure/testBuildFailure.log >/dev/null
      )
      touch $out
    '';

  test-installPhase-modified-symlink =
    basePkgs.runCommand "test-installPhase-modified-symlink" {
      failure = testers.testBuildFailure (
        test-happy.overrideAttrs {
          installCheckPhase = ''
            ln -sf ../bin/script $out/symlink
          '';
        }
      );
    } ''
      echo $failure/testBuildFailure.log
      (
        set -x
        grep 'ERROR: Files were changed during installCheckPhase' $failure/testBuildFailure.log >/dev/null
        grep "$failure/symlink" $failure/testBuildFailure.log >/dev/null
      )
      touch $out
    '';

  test-installPhase-modified-new-symlink =
    basePkgs.runCommand "test-installPhase-modified-new-symlink" {
      failure = testers.testBuildFailure (
        test-happy.overrideAttrs {
          installCheckPhase = ''
            ln -sf ../bin/script $out/new
          '';
        }
      );
    } ''
      echo $failure/testBuildFailure.log
      (
        set -x
        grep 'ERROR: Files were changed during installCheckPhase' $failure/testBuildFailure.log >/dev/null
        grep "$failure/new" $failure/testBuildFailure.log >/dev/null
      )
      touch $out
    '';
}
