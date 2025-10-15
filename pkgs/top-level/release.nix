/*
  This file defines the builds that constitute the Nixpkgs.
  Everything defined here ends up in the Nixpkgs channel.  Individual
  jobs can be tested by running:

  $ nix-build pkgs/top-level/release.nix -A <jobname>.<system>

  e.g.

  $ nix-build pkgs/top-level/release.nix -A coreutils.x86_64-linux
*/
{
  nixpkgs ? {
    outPath = (import ../../lib).cleanSource ../..;
    revCount = 1234;
    shortRev = "abcdef";
    revision = "0000000000000000000000000000000000000000";
  },
  system ? builtins.currentSystem,
  officialRelease ? false,
  # The platform doubles for which we build Nixpkgs.
  supportedSystems ? builtins.fromJSON (builtins.readFile ../../ci/supportedSystems.json),
  # The platform triples for which we build bootstrap tools.
  bootstrapConfigs ? [
    "aarch64-apple-darwin"
    "aarch64-unknown-linux-gnu"
    "aarch64-unknown-linux-musl"
    "i686-unknown-linux-gnu"
    "x86_64-apple-darwin"
    "x86_64-unknown-linux-gnu"
    "x86_64-unknown-linux-musl"
    # we can uncomment that once our bootstrap tarballs are fixed
    #"x86_64-unknown-freebsd"
  ],
  # Strip most of attributes when evaluating to spare memory usage
  scrubJobs ? true,
  # Attributes passed to nixpkgs. Don't build packages marked as unfree.
  nixpkgsArgs ? {
    config = {
      allowUnfree = false;
      inHydra = true;
      # Exceptional unsafe packages that we still build and distribute,
      # so users choosing to allow don't have to rebuild them every time.
      permittedInsecurePackages = [
        "olm-3.2.16" # see PR #347899
        "kanidm_1_6-1.6.4"
        "kanidmWithSecretProvisioning_1_6-1.6.4"
      ];
    };

    __allowFileset = false;
  },

  # This flag, if set to true, will inhibit the use of `mapTestOn`
  # and `release-lib.packagePlatforms`.  Generally, it causes the
  # resulting tree of attributes to *not* have a ".${system}"
  # suffixed upon every job name like Hydra expects.
  #
  # This flag exists mainly for use by ci/eval/attrpaths.nix; see
  # that file for full details.  The exact behavior of this flag
  # may change; it should be considered an internal implementation
  # detail of ci/eval.
  attrNamesOnly ? false,
}:

let
  release-lib = import ./release-lib.nix {
    inherit
      supportedSystems
      scrubJobs
      nixpkgsArgs
      system
      ;
  };

  inherit (release-lib) mapTestOn pkgs;

  inherit (release-lib.lib)
    collect
    elem
    genAttrs
    hasInfix
    hasSuffix
    id
    isDerivation
    optionals
    recursiveUpdate
    ;

  inherit (release-lib.lib.attrsets) unionOfDisjoint;

  supportDarwin = genAttrs [
    "x86_64"
    "aarch64"
  ] (arch: elem "${arch}-darwin" supportedSystems);

  nonPackageJobs = rec {
    tarball = import ./make-tarball.nix {
      inherit
        pkgs
        lib-tests
        nixpkgs
        officialRelease
        ;
    };

    release-checks = import ./nixpkgs-basic-release-checks.nix {
      inherit pkgs nixpkgs supportedSystems;
    };

    manual = pkgs.nixpkgs-manual.override { inherit nixpkgs; };
    metrics = import ./metrics.nix { inherit pkgs nixpkgs; };
    lib-tests = import ../../lib/tests/release.nix {
      pkgs = import nixpkgs (
        recursiveUpdate
          (recursiveUpdate {
            inherit system;
            config.allowUnsupportedSystem = true;
          } nixpkgsArgs)
          {
            config.permittedInsecurePackages = nixpkgsArgs.config.permittedInsecurePackages or [ ] ++ [
              "nix-2.3.18"
            ];
          }
      );
    };
    pkgs-lib-tests = import ../pkgs-lib/tests { inherit pkgs; };

    darwin-tested =
      if supportDarwin.x86_64 || supportDarwin.aarch64 then
        pkgs.releaseTools.aggregate {
          name = "nixpkgs-darwin-${jobs.tarball.version}";
          meta.description = "Release-critical builds for the Nixpkgs darwin channel";
          constituents = [
            jobs.tarball
            jobs.release-checks
          ]
          ++ optionals supportDarwin.x86_64 [
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
            jobs.transmission_3-gtk.x86_64-darwin
            jobs.transmission_4-gtk.x86_64-darwin

            # Tests
            /*
              jobs.tests.cc-wrapper.default.x86_64-darwin
              jobs.tests.cc-wrapper.llvmPackages.clang.x86_64-darwin
              jobs.tests.cc-wrapper.llvmPackages.libcxx.x86_64-darwin
              jobs.tests.stdenv-inputs.x86_64-darwin
              jobs.tests.macOSSierraShared.x86_64-darwin
              jobs.tests.stdenv.hooks.patch-shebangs.x86_64-darwin
            */
          ]
          ++ optionals supportDarwin.aarch64 [
            jobs.cabal2nix.aarch64-darwin
            jobs.ghc.aarch64-darwin
            jobs.git.aarch64-darwin
            jobs.go.aarch64-darwin
            jobs.mariadb.aarch64-darwin
            jobs.nix.aarch64-darwin
            jobs.nixpkgs-review.aarch64-darwin
            jobs.nix-info.aarch64-darwin
            jobs.nix-info-tested.aarch64-darwin
            jobs.openssh.aarch64-darwin
            jobs.openssl.aarch64-darwin
            jobs.pandoc.aarch64-darwin
            jobs.postgresql.aarch64-darwin
            jobs.python3.aarch64-darwin
            jobs.ruby.aarch64-darwin
            jobs.rustc.aarch64-darwin
            # blocking ofBorg CI 2020-02-28
            # jobs.stack.aarch64-darwin
            jobs.stdenv.aarch64-darwin
            jobs.vim.aarch64-darwin
            jobs.cachix.aarch64-darwin
            jobs.darwin.linux-builder.aarch64-darwin

            # UI apps
            # jobs.firefox-unwrapped.aarch64-darwin
            jobs.qt5.qtmultimedia.aarch64-darwin
            jobs.inkscape.aarch64-darwin
            jobs.gimp.aarch64-darwin
            jobs.emacs.aarch64-darwin
            jobs.wireshark.aarch64-darwin
            jobs.transmission_3-gtk.aarch64-darwin
            jobs.transmission_4-gtk.aarch64-darwin

            # Tests
            /*
              jobs.tests.cc-wrapper.default.aarch64-darwin
              jobs.tests.cc-wrapper.llvmPackages.clang.aarch64-darwin
              jobs.tests.cc-wrapper.llvmPackages.libcxx.aarch64-darwin
              jobs.tests.stdenv-inputs.aarch64-darwin
              jobs.tests.macOSSierraShared.aarch64-darwin
              jobs.tests.stdenv.hooks.patch-shebangs.aarch64-darwin
            */
          ];
        }
      else
        null;

    unstable = pkgs.releaseTools.aggregate {
      name = "nixpkgs-${jobs.tarball.version}";
      meta.description = "Release-critical builds for the Nixpkgs unstable channel";
      constituents = [
        jobs.tarball
        jobs.release-checks
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
        jobs.devenv.x86_64-linux

        /*
          TODO: re-add tests; context: https://github.com/NixOS/nixpkgs/commit/36587a587ab191eddd868179d63c82cdd5dee21b

          jobs.tests.cc-wrapper.default.x86_64-linux

          # broken see issue #40038

          jobs.tests.cc-wrapper.llvmPackages.clang.x86_64-linux
          jobs.tests.cc-wrapper.llvmPackages.libcxx.x86_64-linux
          jobs.tests.cc-multilib-gcc.x86_64-linux
          jobs.tests.cc-multilib-clang.x86_64-linux
          jobs.tests.stdenv-inputs.x86_64-linux
          jobs.tests.stdenv.hooks.patch-shebangs.x86_64-linux
        */
      ]
      ++ collect isDerivation jobs.stdenvBootstrapTools
      ++ optionals supportDarwin.x86_64 [
        jobs.stdenv.x86_64-darwin
        jobs.cargo.x86_64-darwin
        jobs.cachix.x86_64-darwin
        jobs.devenv.x86_64-darwin
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
          jobs.tests.cc-wrapper.llvmPackages.clang.x86_64-darwin
          jobs.tests.cc-wrapper.llvmPackages.libcxx.x86_64-darwin
          jobs.tests.stdenv-inputs.x86_64-darwin
          jobs.tests.macOSSierraShared.x86_64-darwin
          jobs.tests.stdenv.hooks.patch-shebangs.x86_64-darwin
        */
      ]
      ++ optionals supportDarwin.aarch64 [
        jobs.stdenv.aarch64-darwin
        jobs.cargo.aarch64-darwin
        jobs.cachix.aarch64-darwin
        jobs.devenv.aarch64-darwin
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
        jobs.darwin.linux-builder.aarch64-darwin
        # consider adding tests, as suggested above for x86_64-darwin
      ];
    };

    stdenvBootstrapTools = genAttrs bootstrapConfigs (
      config:
      if hasInfix "-linux-" config then
        let
          bootstrap = import ../stdenv/linux/make-bootstrap-tools.nix {
            pkgs = import ../.. {
              localSystem = { inherit config; };
            };
          };
        in
        {
          inherit (bootstrap) build test;
        }
      else if hasSuffix "-darwin" config then
        let
          bootstrap = import ../stdenv/darwin/make-bootstrap-tools.nix {
            localSystem = { inherit config; };
          };
        in
        {
          # Lightweight distribution and test
          inherit (bootstrap) build test;
          # Test a full stdenv bootstrap from the bootstrap tools definition
          # TODO: Re-enable once the new bootstrap-tools are in place.
          #inherit (bootstrap.test-pkgs) stdenv;
        }
      else if hasSuffix "-freebsd" config then
        let
          bootstrap = import ../stdenv/freebsd/make-bootstrap-tools.nix {
            pkgs = import ../.. {
              localSystem = { inherit config; };
            };
          };
        in
        {
          inherit (bootstrap) build; # test does't exist yet
        }
      else
        abort "No bootstrap implementation for system: ${config}"
    );
  };

  # Do not allow attribute collision between jobs inserted in
  # 'nonPackageAttrs' and jobs pulled in from 'pkgs'.
  # Conflicts usually cause silent job drops like in
  #   https://github.com/NixOS/nixpkgs/pull/182058
  jobs =
    let
      packagePlatforms = release-lib.recursiveMapPackages (
        if attrNamesOnly then id else release-lib.getPlatforms
      );
      packageJobs = packagePlatforms pkgs // {
        # Build selected packages (HLS) for multiple Haskell compilers to rebuild
        # the cache after a staging merge
        haskell = packagePlatforms pkgs.haskell // {
          packages =
            genAttrs
              [
                # TODO: share this list between release.nix and release-haskell.nix
                "ghc90"
                "ghc92"
                "ghc94"
                "ghc96"
                "ghc98"
                "ghc910"
                "ghc912"
              ]
              (compilerName: {
                inherit (packagePlatforms pkgs.haskell.packages.${compilerName})
                  haskell-language-server
                  ;
              });
        };

        pkgsLLVM.stdenv = [
          "x86_64-linux"
          "aarch64-linux"
        ];
        pkgsArocc.stdenv = [
          "x86_64-linux"
          "aarch64-linux"
        ];
        pkgsZig.stdenv = [
          "x86_64-linux"
          "aarch64-linux"
        ];
        pkgsMusl.stdenv = [
          "x86_64-linux"
          "aarch64-linux"
        ];
        pkgsStatic.stdenv = [
          "x86_64-linux"
          "aarch64-linux"
        ];

        # Fails CI in its current state
        ocamlPackages = { };
      };
      mapTestOn-packages = if attrNamesOnly then packageJobs else mapTestOn packageJobs;
    in
    unionOfDisjoint nonPackageJobs mapTestOn-packages;

in
jobs
