/* This file defines the builds that constitute the Nixpkgs.
   Everything defined here ends up in the Nixpkgs channel.  Individual
   jobs can be tested by running:

   $ nix-build pkgs/top-level/release.nix -A <jobname>.<system>

   e.g.

   $ nix-build pkgs/top-level/release.nix -A coreutils.x86_64-linux
*/
{ nixpkgs ? { outPath = (import ../../lib).cleanSource ../..; revCount = 1234; shortRev = "abcdef"; revision = "0000000000000000000000000000000000000000"; }
, officialRelease ? false
  # The platform doubles for which we build Nixpkgs.
, supportedSystems ? [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ]
  # The platform triples for which we build bootstrap tools.
, bootstrapConfigs ? [
    "aarch64-apple-darwin"
    "aarch64-unknown-linux-gnu"
    "aarch64-unknown-linux-musl"
    "i686-unknown-linux-gnu"
    "x86_64-apple-darwin"
    "x86_64-unknown-linux-gnu"
    "x86_64-unknown-linux-musl"
  ]
  # Strip most of attributes when evaluating to spare memory usage
, scrubJobs ? true
  # Attributes passed to nixpkgs. Don't build packages marked as unfree.
, nixpkgsArgs ? { config = {
    allowUnfree = false;
    inHydra = true;
    permittedInsecurePackages = [
      # *Exceptionally*, those packages will be cached with their *secure* dependents
      # because they will reach EOL in the middle of the 23.05 release
      # and it will be too much painful for our users to recompile them
      # for no real reason.
      # Remove them for 23.11.
      "nodejs-16.20.2"
      "openssl-1.1.1w"
    ];
  }; }
}:

with import ./release-lib.nix { inherit supportedSystems scrubJobs nixpkgsArgs; };

let

  supportDarwin = lib.genAttrs [
    "x86_64"
    "aarch64"
  ] (arch: builtins.elem "${arch}-darwin" supportedSystems);

  nonPackageJobs =
    { tarball = import ./make-tarball.nix { inherit pkgs nixpkgs officialRelease supportedSystems; };

      metrics = import ./metrics.nix { inherit pkgs nixpkgs; };

      manual = import ../../doc { inherit pkgs nixpkgs; };
      lib-tests = import ../../lib/tests/release.nix { inherit pkgs; };
      pkgs-lib-tests = import ../pkgs-lib/tests { inherit pkgs; };

      darwin-tested = if supportDarwin.x86_64 then pkgs.releaseTools.aggregate
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
              jobs.python3.x86_64-darwin
              jobs.ruby.x86_64-darwin
              jobs.rustc.x86_64-darwin
              # blocking ofBorg CI 2020-02-28
              # jobs.stack.x86_64-darwin
              jobs.stdenv.x86_64-darwin
              jobs.vim.x86_64-darwin
              jobs.cachix.x86_64-darwin
              jobs.darwin.linux-builder.x86_64-darwin

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
              jobs.tests.cc-wrapper.default.x86_64-darwin
              jobs.tests.cc-wrapper.llvmPackages.clang.x86_64-darwin
              jobs.tests.cc-wrapper.llvmPackages.libcxx.x86_64-darwin
              jobs.tests.stdenv-inputs.x86_64-darwin
              jobs.tests.macOSSierraShared.x86_64-darwin
              jobs.tests.stdenv.hooks.patch-shebangs.x86_64-darwin
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
              jobs.pkgs-lib-tests
              jobs.stdenv.x86_64-linux
              jobs.cargo.x86_64-linux
              jobs.go.x86_64-linux
              jobs.linux.x86_64-linux
              jobs.nix.x86_64-linux
              jobs.pandoc.x86_64-linux
              jobs.python3.x86_64-linux
              # Needed by contributors to test PRs (by inclusion of the PR template)
              jobs.nixpkgs-review.x86_64-linux
              # Needed for support
              jobs.nix-info.x86_64-linux
              jobs.nix-info-tested.x86_64-linux
              # Ensure that X11/GTK are in order.
              jobs.firefox-unwrapped.x86_64-linux
              jobs.cachix.x86_64-linux

              /*
              TODO: re-add tests; context: https://github.com/NixOS/nixpkgs/commit/36587a587ab191eddd868179d63c82cdd5dee21b

              jobs.tests.cc-wrapper.default.x86_64-linux
              jobs.tests.cc-wrapper.gcc7Stdenv.x86_64-linux
              jobs.tests.cc-wrapper.gcc8Stdenv.x86_64-linux

              # broken see issue #40038

              jobs.tests.cc-wrapper.llvmPackages.clang.x86_64-linux
              jobs.tests.cc-wrapper.llvmPackages.libcxx.x86_64-linux
              jobs.tests.cc-wrapper.llvmPackages_5.clang.x86_64-linux
              jobs.tests.cc-wrapper.llvmPackages_5.libcxx.x86_64-linux
              jobs.tests.cc-wrapper.llvmPackages_6.clang.x86_64-linux
              jobs.tests.cc-wrapper.llvmPackages_6.libcxx.x86_64-linux
              jobs.tests.cc-multilib-gcc.x86_64-linux
              jobs.tests.cc-multilib-clang.x86_64-linux
              jobs.tests.stdenv-inputs.x86_64-linux
              jobs.tests.stdenv.hooks.patch-shebangs.x86_64-linux
              */
            ]
            ++ lib.collect lib.isDerivation jobs.stdenvBootstrapTools
            ++ lib.optionals supportDarwin.x86_64 [
              jobs.stdenv.x86_64-darwin
              jobs.cargo.x86_64-darwin
              jobs.cachix.x86_64-darwin
              jobs.go.x86_64-darwin
              jobs.python3.x86_64-darwin
              jobs.nixpkgs-review.x86_64-darwin
              jobs.nix.x86_64-darwin
              jobs.nix-info.x86_64-darwin
              jobs.nix-info-tested.x86_64-darwin
              jobs.git.x86_64-darwin
              jobs.mariadb.x86_64-darwin
              jobs.vim.x86_64-darwin
              jobs.inkscape.x86_64-darwin
              jobs.qt5.qtmultimedia.x86_64-darwin
              jobs.darwin.linux-builder.x86_64-darwin
              /*
              jobs.tests.cc-wrapper.default.x86_64-darwin
              jobs.tests.cc-wrapper.gcc7Stdenv.x86_64-darwin
              jobs.tests.cc-wrapper.gcc8Stdenv.x86_64-darwin
              jobs.tests.cc-wrapper.llvmPackages.clang.x86_64-darwin
              jobs.tests.cc-wrapper.llvmPackages.libcxx.x86_64-darwin
              jobs.tests.cc-wrapper.llvmPackages_5.clang.x86_64-darwin
              jobs.tests.cc-wrapper.llvmPackages_5.libcxx.x86_64-darwin
              jobs.tests.cc-wrapper.llvmPackages_6.clang.x86_64-darwin
              jobs.tests.cc-wrapper.llvmPackages_6.libcxx.x86_64-darwin
              jobs.tests.stdenv-inputs.x86_64-darwin
              jobs.tests.macOSSierraShared.x86_64-darwin
              jobs.tests.stdenv.hooks.patch-shebangs.x86_64-darwin
              */
            ]
            ++ lib.optionals supportDarwin.aarch64 [
              jobs.stdenv.aarch64-darwin
              jobs.cargo.aarch64-darwin
              jobs.cachix.aarch64-darwin
              jobs.go.aarch64-darwin
              jobs.python3.aarch64-darwin
              jobs.nixpkgs-review.aarch64-darwin
              jobs.nix.aarch64-darwin
              jobs.nix-info.aarch64-darwin
              jobs.nix-info-tested.aarch64-darwin
              jobs.git.aarch64-darwin
              jobs.mariadb.aarch64-darwin
              jobs.vim.aarch64-darwin
              jobs.inkscape.aarch64-darwin
              jobs.qt5.qtmultimedia.aarch64-darwin
              /* consider adding tests, as suggested above for x86_64-darwin */
            ];
        };

      stdenvBootstrapTools = with lib;
        genAttrs bootstrapConfigs (config:
          if hasInfix "-linux-" config then
            let
              bootstrap = import ../stdenv/linux/make-bootstrap-tools.nix {
                pkgs = import ../.. {
                  localSystem = { inherit config; };
                };
              };
            in {
              inherit (bootstrap) dist test;
            }
          else if hasSuffix "-darwin" config then
            let
              bootstrap = import ../stdenv/darwin/make-bootstrap-tools.nix {
                localSystem = { inherit config; };
              };
            in {
              # Lightweight distribution and test
              inherit (bootstrap) dist test;
              # Test a full stdenv bootstrap from the bootstrap tools definition
              # TODO: Re-enable once the new bootstrap-tools are in place.
              #inherit (bootstrap.test-pkgs) stdenv;
            }
          else
            abort "No bootstrap implementation for system: ${config}"
        );
    };

  # Do not allow attribute collision between jobs inserted in
  # 'nonPackageAttrs' and jobs pulled in from 'pkgs'.
  # Conflicts usually cause silent job drops like in
  #   https://github.com/NixOS/nixpkgs/pull/182058
  jobs = lib.attrsets.unionOfDisjoint
    nonPackageJobs
    (mapTestOn ((packagePlatforms pkgs) // {
      haskell.compiler = packagePlatforms pkgs.haskell.compiler;
      haskellPackages = packagePlatforms pkgs.haskellPackages;
      idrisPackages = packagePlatforms pkgs.idrisPackages;
      agdaPackages = packagePlatforms pkgs.agdaPackages;

      pkgsLLVM.stdenv = [ "x86_64-linux" "aarch64-linux" ];
      pkgsMusl.stdenv = [ "x86_64-linux" "aarch64-linux" ];
      pkgsStatic.stdenv = [ "x86_64-linux" "aarch64-linux" ];

      tests = packagePlatforms pkgs.tests;

      # Language packages disabled in https://github.com/NixOS/nixpkgs/commit/ccd1029f58a3bb9eca32d81bf3f33cb4be25cc66

      #emacsPackages = packagePlatforms pkgs.emacsPackages;
      #rPackages = packagePlatforms pkgs.rPackages;
      ocamlPackages = { };
      perlPackages = { };

      darwin = packagePlatforms pkgs.darwin // {
        xcode = {};
      };
    } ));

in jobs
