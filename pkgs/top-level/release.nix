/* This file defines the builds that constitute the Nixpkgs.
   Everything defined here ends up in the Nixpkgs channel.  Individual
   jobs can be tested by running:

   $ nix-build pkgs/top-level/release.nix -A <jobname>.<system>

   e.g.

   $ nix-build pkgs/top-level/release.nix -A coreutils.x86_64-linux
*/
{ nixpkgs ? { outPath = (import ../../lib).cleanSource ../..; revCount = 1234; shortRev = "abcdef"; }
, officialRelease ? false
  # The platforms for which we build Nixpkgs.
, supportedSystems ? [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" ]
, limitedSupportedSystems ? [ "i686-linux" ]
  # Strip most of attributes when evaluating to spare memory usage
,  scrubJobs ? true
  # Attributes passed to nixpkgs. Don't build packages marked as unfree.
,  nixpkgsArgs ? { config = { allowUnfree = false; inHydra = true; }; }
}:

with import ./release-lib.nix { inherit supportedSystems scrubJobs nixpkgsArgs; };

let

  systemsWithAnySupport = supportedSystems ++ limitedSupportedSystems;

  jobs =
    { tarball = import ./make-tarball.nix { inherit pkgs nixpkgs officialRelease; };

      metrics = import ./metrics.nix { inherit pkgs nixpkgs; };

      manual = import ../../doc;
      lib-tests = import ../../lib/tests/release.nix { inherit pkgs; };

      darwin-tested = pkgs.releaseTools.aggregate
        { name = "nixpkgs-darwin-${jobs.tarball.version}";
          meta.description = "Release-critical builds for the Nixpkgs darwin channel";
          constituents =
            [ jobs.tarball
              jobs.stdenv.x86_64-darwin
              jobs.ghc.x86_64-darwin
              jobs.cabal2nix.x86_64-darwin
              jobs.ruby.x86_64-darwin
              jobs.python.x86_64-darwin
              jobs.rustc.x86_64-darwin
              jobs.go.x86_64-darwin
              jobs.tests.macOSSierraShared.x86_64-darwin
            ];
        };

      unstable = pkgs.releaseTools.aggregate
        { name = "nixpkgs-${jobs.tarball.version}";
          meta.description = "Release-critical builds for the Nixpkgs unstable channel";
          constituents =
            [ jobs.tarball
              jobs.metrics
              jobs.manual
              jobs.lib-tests
              jobs.stdenv.x86_64-linux
              jobs.stdenv.x86_64-darwin
              jobs.linux.x86_64-linux
              jobs.python.x86_64-linux
              jobs.python.x86_64-darwin
              jobs.python3.x86_64-linux
              jobs.python3.x86_64-darwin
              # Many developers use nix-repl
              jobs.nix-repl.x86_64-linux
              jobs.nix-repl.x86_64-darwin
              # Needed by travis-ci to test PRs
              jobs.nox.x86_64-linux
              jobs.nox.x86_64-darwin
              # Ensure that X11/GTK+ are in order.
              jobs.thunderbird.x86_64-linux
              # Ensure that basic stuff works on darwin
              jobs.git.x86_64-darwin
              jobs.mysql.x86_64-darwin
              jobs.vim.x86_64-darwin
            ] ++ lib.collect lib.isDerivation jobs.stdenvBootstrapTools;
        };

      stdenvBootstrapTools = with lib;
        genAttrs systemsWithAnySupport
          (system: {
            inherit (import ../stdenv/linux/make-bootstrap-tools.nix { inherit system; })
              dist test;
          })
        # darwin is special in this
        // optionalAttrs (builtins.elem "x86_64-darwin" systemsWithAnySupport) {
          x86_64-darwin =
            let
              bootstrap = import ../stdenv/darwin/make-bootstrap-tools.nix { system = "x86_64-darwin"; };
            in {
              # Lightweight distribution and test
              inherit (bootstrap) dist test;
              # Test a full stdenv bootstrap from the bootstrap tools definition
              inherit (bootstrap.test-pkgs) stdenv;
            };
          };

    } // (mapTestOn ((packagePlatforms pkgs) // rec {
      haskell.compiler = packagePlatforms pkgs.haskell.compiler;
      haskellPackages = packagePlatforms pkgs.haskellPackages;

      # Language packages disabled in https://github.com/NixOS/nixpkgs/commit/ccd1029f58a3bb9eca32d81bf3f33cb4be25cc66

      #emacsPackagesNg = packagePlatforms pkgs.emacsPackagesNg;
      #rPackages = packagePlatforms pkgs.rPackages;
      ocamlPackages = { };
      perlPackages = { };
      pythonPackages = {
        blaze = unix;
        pandas = unix;
        scikitlearn = unix;
      };
      python2Packages = { };
      python27Packages = { };
      python3Packages = { };
      python35Packages = {
        blaze = unix;
        pandas = unix;
        scikitlearn = unix;
      };
      python36Packages = {
        blaze = unix;
        pandas = unix;
        scikitlearn = unix;
      };

      # hack around broken eval of non-linux packages for now.
      tests.macOSSierraShared = darwin;
    } ));

in jobs
