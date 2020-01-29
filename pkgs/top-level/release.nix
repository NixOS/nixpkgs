/* This file defines the builds that constitute the Nixpkgs.
   Everything defined here ends up in the Nixpkgs channel.  Individual
   jobs can be tested by running:

   $ nix-build pkgs/top-level/release.nix -A <jobname>.<system>

   e.g.

   $ nix-build pkgs/top-level/release.nix -A coreutils.x86_64-linux
*/
{ nixpkgs ? { outPath = (import ../../lib).cleanSource ../..; revCount = 1234; shortRev = "abcdef"; revision = "0000000000000000000000000000000000000000"; }
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

  supportDarwin = builtins.elem "x86_64-darwin" systemsWithAnySupport;

  jobs =
    { tarball = import ./make-tarball.nix { inherit pkgs nixpkgs officialRelease; };

      metrics = import ./metrics.nix { inherit pkgs nixpkgs; };

      manual = import ../../doc { inherit pkgs nixpkgs; };
      lib-tests = import ../../lib/tests/release.nix { inherit pkgs; };

      darwin-tested = if supportDarwin then pkgs.releaseTools.aggregate
        { name = "nixpkgs-darwin-${jobs.tarball.version}";
          meta.description = "Release-critical builds for the Nixpkgs darwin channel";
          constituents =
            [ jobs.tarball
              jobs.cabal2nix.x86_64-darwin
              jobs.ghc.x86_64-darwin
              jobs.git.x86_64-darwin
              jobs.go.x86_64-darwin
              jobs.mariadb.x86_64-darwin
              jobs.nix.x86_64-darwin
              jobs.nixpkgs-review.x86_64-darwin
              jobs.nix-info.x86_64-darwin
              jobs.nix-info-tested.x86_64-darwin
              jobs.openssh.x86_64-darwin
              jobs.openssl.x86_64-darwin
              jobs.pandoc.x86_64-darwin
              jobs.postgresql.x86_64-darwin
              jobs.python.x86_64-darwin
              jobs.python3.x86_64-darwin
              jobs.ruby.x86_64-darwin
              jobs.rustc.x86_64-darwin
              jobs.stack.x86_64-darwin
              jobs.stdenv.x86_64-darwin
              jobs.vim.x86_64-darwin
              jobs.cachix.x86_64-darwin

              # UI apps
              # jobs.firefox-unwrapped.x86_64-darwin
              jobs.qt5.qtmultimedia.x86_64-darwin
              jobs.inkscape.x86_64-darwin
              jobs.gimp.x86_64-darwin
              jobs.emacs.x86_64-darwin
              jobs.wireshark.x86_64-darwin
              jobs.transmission-gtk.x86_64-darwin

              # Tests
              /*
              jobs.tests.cc-wrapper.x86_64-darwin
              jobs.tests.cc-wrapper-clang.x86_64-darwin
              jobs.tests.cc-wrapper-libcxx.x86_64-darwin
              jobs.tests.cc-wrapper-clang-39.x86_64-darwin
              jobs.tests.cc-wrapper-libcxx-39.x86_64-darwin
              jobs.tests.stdenv-inputs.x86_64-darwin
              jobs.tests.macOSSierraShared.x86_64-darwin
              jobs.tests.patch-shebangs.x86_64-darwin
              */
            ];
        } else null;

      unstable = pkgs.releaseTools.aggregate
        { name = "nixpkgs-${jobs.tarball.version}";
          meta.description = "Release-critical builds for the Nixpkgs unstable channel";
          constituents =
            [ jobs.tarball
              jobs.metrics
              jobs.manual
              jobs.lib-tests
              jobs.stdenv.x86_64-linux
              jobs.linux.x86_64-linux
              jobs.pandoc.x86_64-linux
              jobs.python.x86_64-linux
              jobs.python3.x86_64-linux
              # Needed by contributors to test PRs (by inclusion of the PR template)
              jobs.nixpkgs-review.x86_64-linux
              # Needed for support
              jobs.nix-info.x86_64-linux
              jobs.nix-info-tested.x86_64-linux
              # Ensure that X11/GTK are in order.
              jobs.thunderbird.x86_64-linux
              jobs.cachix.x86_64-linux

              /*
              jobs.tests.cc-wrapper.x86_64-linux
              jobs.tests.cc-wrapper-gcc7.x86_64-linux
              jobs.tests.cc-wrapper-gcc8.x86_64-linux

              # broken see issue #40038

              jobs.tests.cc-wrapper-clang.x86_64-linux
              jobs.tests.cc-wrapper-libcxx.x86_64-linux
              jobs.tests.cc-wrapper-clang-39.x86_64-linux
              jobs.tests.cc-wrapper-libcxx-39.x86_64-linux
              jobs.tests.cc-wrapper-clang-4.x86_64-linux
              jobs.tests.cc-wrapper-libcxx-4.x86_64-linux
              jobs.tests.cc-wrapper-clang-5.x86_64-linux
              jobs.tests.cc-wrapper-libcxx-5.x86_64-linux
              jobs.tests.cc-wrapper-clang-6.x86_64-linux
              jobs.tests.cc-wrapper-libcxx-6.x86_64-linux
              jobs.tests.cc-multilib-gcc.x86_64-linux
              jobs.tests.cc-multilib-clang.x86_64-linux
              jobs.tests.stdenv-inputs.x86_64-linux
              jobs.tests.patch-shebangs.x86_64-linux
              */
            ]
            ++ lib.collect lib.isDerivation jobs.stdenvBootstrapTools
            ++ lib.optionals supportDarwin [
              jobs.stdenv.x86_64-darwin
              jobs.python.x86_64-darwin
              jobs.python3.x86_64-darwin
              jobs.nixpkgs-review.x86_64-darwin
              jobs.nix-info.x86_64-darwin
              jobs.nix-info-tested.x86_64-darwin
              jobs.git.x86_64-darwin
              jobs.mariadb.x86_64-darwin
              jobs.vim.x86_64-darwin
              jobs.inkscape.x86_64-darwin
              jobs.qt5.qtmultimedia.x86_64-darwin
              /*
              jobs.tests.cc-wrapper.x86_64-darwin
              jobs.tests.cc-wrapper-gcc7.x86_64-darwin
              # jobs.tests.cc-wrapper-gcc8.x86_64-darwin
              jobs.tests.cc-wrapper-clang.x86_64-darwin
              jobs.tests.cc-wrapper-libcxx.x86_64-darwin
              jobs.tests.cc-wrapper-clang-39.x86_64-darwin
              jobs.tests.cc-wrapper-libcxx-39.x86_64-darwin
              jobs.tests.cc-wrapper-clang-4.x86_64-darwin
              jobs.tests.cc-wrapper-libcxx-4.x86_64-darwin
              jobs.tests.cc-wrapper-clang-5.x86_64-darwin
              jobs.tests.cc-wrapper-libcxx-6.x86_64-darwin
              jobs.tests.cc-wrapper-clang-6.x86_64-darwin
              jobs.tests.cc-wrapper-libcxx-6.x86_64-darwin
              jobs.tests.stdenv-inputs.x86_64-darwin
              jobs.tests.macOSSierraShared.x86_64-darwin
              jobs.tests.patch-shebangs.x86_64-darwin
              */
            ];
        };

      stdenvBootstrapTools = with lib;
        genAttrs systemsWithAnySupport
          (system: {
            inherit
              (import ../stdenv/linux/make-bootstrap-tools.nix {
                localSystem = { inherit system; };
              })
              dist test;
          })
        # darwin is special in this
        // optionalAttrs supportDarwin {
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

    } // (mapTestOn ((packagePlatforms pkgs) // {
      haskell.compiler = packagePlatforms pkgs.haskell.compiler;
      haskellPackages = packagePlatforms pkgs.haskellPackages;
      idrisPackages = packagePlatforms pkgs.idrisPackages;

      tests = packagePlatforms pkgs.tests;

      # Language packages disabled in https://github.com/NixOS/nixpkgs/commit/ccd1029f58a3bb9eca32d81bf3f33cb4be25cc66

      #emacsPackages = packagePlatforms pkgs.emacsPackages;
      #rPackages = packagePlatforms pkgs.rPackages;
      ocamlPackages = { };
      perlPackages = { };

      darwin = packagePlatforms pkgs.darwin // {
        cf-private = {};
        xcode = {};
      };
    } ));

in jobs
