/*
  This is the Hydra jobset for the `haskell-updates` branch in Nixpkgs.
  You can see the status of this jobset at
  https://hydra.nixos.org/jobset/nixpkgs/haskell-updates.

  To debug this expression you can use `hydra-eval-jobs` from
  `pkgs.hydra` which prints the jobset description
  to `stdout`:

  $ hydra-eval-jobs -I . pkgs/top-level/release-haskell.nix
*/
{
  supportedSystems ? builtins.fromJSON (builtins.readFile ../../ci/supportedSystems.json),
}:

let

  releaseLib = import ./release-lib.nix {
    inherit supportedSystems;
  };

  inherit (releaseLib)
    lib
    mapTestOn
    packagePlatforms
    pkgs
    ;

  # Helper function which traverses a (nested) set
  # of derivations produced by mapTestOn and flattens
  # it to a list of derivations suitable to be passed
  # to `releaseTools.aggregate` as constituents.
  # Removes all non derivations from the input jobList.
  #
  # accumulateDerivations :: [ Either Derivation AttrSet ] -> [ Derivation ]
  #
  # > accumulateDerivations [ drv1 "string" { foo = drv2; bar = { baz = drv3; }; } ]
  # [ drv1 drv2 drv3 ]
  accumulateDerivations =
    jobList:
    lib.concatMap (
      attrs:
      if lib.isDerivation attrs then
        [ attrs ]
      else
        lib.optionals (lib.isAttrs attrs) (accumulateDerivations (lib.attrValues attrs))
    ) jobList;

  # names of all subsets of `pkgs.haskell.packages`
  #
  # compilerNames looks like the following:
  #
  # ```
  # {
  #   ghc810 = "ghc810";
  #   ghc8107Binary = "ghc8107Binary";
  #   ghc8107 = "ghc8107";
  #   ghc924 = "ghc924";
  #   ...
  # }
  # ```
  compilerNames = lib.mapAttrs (name: _: name) pkgs.haskell.packages;

  # list of all compilers to test specific packages on
  released = with compilerNames; [
    ghc948
    ghc967
    ghc984
    ghc9102
    ghc9103
    ghc9122
  ];

  # packagePlatforms applied to `haskell.packages.*`
  #
  # This returns an attr set that looks like the following, where each Haskell
  # package in the compiler attr set has its list of supported platforms as its
  # value.
  #
  # ```
  # {
  #   ghc810 = {
  #     conduit = [ ... ];
  #     lens = [ "i686-cygwin" "x86_64-cygwin" ... "x86_64-windows" "i686-windows" ]
  #     ...
  #   };
  #   ghc902 = { ... };
  #   ...
  # }
  # ```
  compilerPlatforms = lib.mapAttrs (_: v: packagePlatforms v) pkgs.haskell.packages;

  # This function lets you specify specific packages
  # which are to be tested on a list of specific GHC
  # versions and returns a job set for all specified
  # combinations.
  #
  # You can call versionedCompilerJobs like the following:
  #
  # ```
  # versionedCompilerJobs {
  #   ghc-tags = ["ghc902" "ghc924"];
  # }
  # ```
  #
  # This would produce an output like the following:
  #
  # ```
  # {
  #   haskell.packages = {
  #     ghc884 = {};
  #     ghc810 = {};
  #     ghc902 = {
  #       ghc-tags = {
  #         aarch64-darwin = <derivation...>;
  #         aarch64-linux = <derivation...>;
  #         ...
  #       };
  #     };
  #     ghc924 = {
  #       ghc-tags = { ... };
  #     };
  #     ...
  #   };
  # }
  # ```
  versionedCompilerJobs =
    config:
    mapTestOn {
      haskell.packages =
        let
          # Mapping function that takes an attrset of jobs, and
          # removes all jobs that are not specified in config.
          #
          # For example, imagine a call to onlyConfigJobs like:
          #
          # ```
          # onlyConfigJobs
          #   "ghc902"
          #   {
          #     conduit = [ ... ];
          #     lens = [ "i686-cygwin" "x86_64-cygwin" ... "x86_64-windows" "i686-windows" ];
          #   }
          # ```
          #
          # onlyConfigJobs pulls out only those jobs that are specified in config.
          #
          # For instance, if config is `{ lens = [ "ghc902" ]; }`, then the above
          # example call to onlyConfigJobs will return:
          #
          # ```
          # { lens = [ "i686-cygwin" "x86_64-cygwin" ... "x86_64-windows" "i686-windows" ]; }
          # ```
          #
          # If config is `{ lens = [ "ghc8107" ]; }`, then the above example call
          # to onlyConfigJobs returns `{}`.
          #
          # onlyConfigJobs will also remove all platforms from a job that are not
          # supported by the GHC it is compiled with.
          onlyConfigJobs =
            ghc: jobs:
            let
              configFilteredJobset = lib.filterAttrs (
                jobName: platforms: lib.elem ghc (config."${jobName}" or [ ])
              ) jobs;

              # Remove platforms from each job that are not supported by GHC.
              # This is important so that we don't build jobs for platforms
              # where GHC can't be compiled.
              jobsetWithGHCPlatforms = lib.mapAttrs (
                _: platforms: lib.intersectLists jobs.ghc platforms
              ) configFilteredJobset;
            in
            jobsetWithGHCPlatforms;
        in
        lib.mapAttrs onlyConfigJobs compilerPlatforms;
    };

  # hydra jobs for `pkgs` of which we import a subset of
  pkgsPlatforms = packagePlatforms pkgs;

  # names of packages in an attribute set that are maintained
  maintainedPkgNames =
    set: builtins.attrNames (lib.filterAttrs (_: v: v.meta.maintainers or [ ] != [ ]) set);

  recursiveUpdateMany = builtins.foldl' lib.recursiveUpdate { };

  # Remove multiple elements from a list at once.
  #
  # removeMany
  #   :: [a]  -- list of elements to remove
  #   -> [a]  -- list of elements from which to remove
  #   -> [a]
  #
  # > removeMany ["aarch64-linux" "x86_64-darwin"] ["aarch64-linux" "x86_64-darwin" "x86_64-linux"]
  # ["x86_64-linux"]
  removeMany = itemsToRemove: list: lib.foldr lib.remove list itemsToRemove;

  # Recursively remove platforms from the values in an attribute set.
  #
  # removePlatforms
  #   :: [String]
  #   -> AttrSet
  #   -> AttrSet
  #
  # > attrSet = {
  #     foo = ["aarch64-linux" "x86_64-darwin" "x86_64-linux"];
  #     bar.baz = ["aarch64-linux" "x86_64-linux"];
  #     bar.quux = ["aarch64-linux" "x86_64-darwin"];
  #   }
  # > removePlatforms ["aarch64-linux" "x86_64-darwin"] attrSet
  # {
  #   foo = ["x86_64-linux"];
  #   bar = {
  #     baz = ["x86_64-linux"];
  #     quux = [];
  #   };
  # }
  removePlatforms =
    platformsToRemove: packageSet:
    lib.mapAttrsRecursive (
      _: val: if lib.isList val then removeMany platformsToRemove val else val
    ) packageSet;

  jobs = recursiveUpdateMany [
    (mapTestOn {
      haskellPackages = packagePlatforms pkgs.haskellPackages;
      haskell.compiler = packagePlatforms pkgs.haskell.compiler;
      tests.haskell = packagePlatforms pkgs.tests.haskell;

      nixosTests = {
        agda = packagePlatforms pkgs.nixosTests.agda;

        inherit (packagePlatforms pkgs.nixosTests)
          kmonad
          xmonad
          xmonad-xdg-autostart
          ;
      };

      agdaPackages = packagePlatforms pkgs.agdaPackages;

      # top-level packages that depend on haskellPackages
      inherit (pkgsPlatforms)
        agda
        alex
        arion
        aws-spend-summary
        bench
        blucontrol
        cabal-install
        cabal2nix
        cachix
        # carp broken on 2024-04-09
        changelog-d
        cedille
        client-ip-echo
        cornelis
        codd
        darcs
        dconf2nix
        dhall
        dhall-bash
        dhall-docs
        dhall-lsp-server
        dhall-json
        dhall-nix
        dhall-nixpkgs
        dhall-yaml
        diagrams-builder
        echidna
        elm2nix
        fffuu
        futhark
        ghcid
        git-annex
        git-brunch
        gitit
        glirc
        hadolint
        happy
        haskell-ci
        haskell-language-server
        hci
        hercules-ci-agent
        hinit
        hedgewars
        hledger
        hledger-check-fancyassertions
        hledger-iadd
        hledger-interest
        hledger-ui
        hledger-web
        hlint
        hpack
        hscolour
        icepeak
        ihaskell
        jacinda
        jl
        json2yaml
        koka
        krank
        lambdabot
        lhs2tex
        madlang
        matterhorn
        mkjson
        mueval
        naproche
        niv
        nix-delegate
        nix-deploy
        nix-diff
        nix-output-monitor
        nix-script
        nix-tree
        nixfmt
        nota
        nvfetcher
        oama
        ormolu
        pakcs
        pandoc
        place-cursor-at
        pinboard-notes-backup
        pretty-simple
        purenix
        shake
        shellcheck
        shellcheck-minimal
        sourceAndTags
        spacecookie
        spago-legacy
        specup
        splot
        stack
        stack2nix
        stutter
        stylish-haskell
        taffybar
        tamarin-prover
        termonad
        tldr-hs
        tweet-hs
        update-nix-fetchgit
        uusi
        uqm
        uuagc
        vaultenv
        xmobar
        xmonadctl
        xmonad-with-packages
        yi
        ;

      # Members of the elmPackages set that are Haskell derivations
      elmPackages = {
        inherit (pkgsPlatforms.elmPackages)
          elm
          elm-format
          ;
      };

      # GHCs linked to musl.
      pkgsMusl =
        removePlatforms
          [
            # pkgsMusl is compiled natively with musl.  It is not
            # cross-compiled (unlike pkgsStatic).  We can only
            # natively bootstrap GHC with musl on x86_64-linux because
            # upstream doesn't provide a musl bindist for aarch64.
            "aarch64-linux"

            # musl only supports linux, not darwin.
            "x86_64-darwin"
            "aarch64-darwin"
          ]
          {
            haskell.compiler = packagePlatforms pkgs.pkgsMusl.haskell.compiler;

            # Get some cache going for MUSL-enabled GHC.
            haskellPackages = {
              inherit (packagePlatforms pkgs.pkgsMusl.haskellPackages)
                hello
                lens
                random
                ;
            };
          };

      # Test some statically linked packages to catch regressions
      # and get some cache going for static compilation with GHC.
      # Use native-bignum to avoid GMP linking problems (LGPL)
      pkgsStatic =
        removePlatforms
          [
            "aarch64-linux" # times out on Hydra

            # Static doesn't work on darwin
            "x86_64-darwin"
            "aarch64-darwin"
          ]
          {
            haskellPackages = {
              inherit (packagePlatforms pkgs.pkgsStatic.haskellPackages)
                hello
                lens
                random
                QuickCheck
                cabal2nix
                terminfo # isn't bundled for cross
                xhtml # isn't bundled for cross
                postgrest
                ;
            };

            haskell.packages.native-bignum.ghc948 = {
              inherit (packagePlatforms pkgs.pkgsStatic.haskell.packages.native-bignum.ghc948)
                hello
                lens
                random
                QuickCheck
                cabal2nix
                terminfo # isn't bundled for cross
                xhtml # isn't bundled for cross
                postgrest
                ;
            };

            haskell.packages.native-bignum.ghc9103 = {
              inherit (packagePlatforms pkgs.pkgsStatic.haskell.packages.native-bignum.ghc9103)
                hello
                random
                QuickCheck
                terminfo # isn't bundled for cross
                ;
            };
          };

      pkgsCross = {
        aarch64-android-prebuilt.pkgsStatic =
          removePlatforms
            [
              # Android NDK package doesn't support building on
              "aarch64-darwin"
              "aarch64-linux"

              "x86_64-darwin"
            ]
            {
              haskell.packages.ghc912 = {
                inherit
                  (packagePlatforms pkgs.pkgsCross.aarch64-android-prebuilt.pkgsStatic.haskell.packages.ghc912)
                  ghc
                  hello
                  microlens
                  ;
              };
            };

        ghcjs =
          removePlatforms
            [
              # Hydra output size of 3GB is exceeded
              "aarch64-linux"
            ]
            {
              haskellPackages = {
                inherit (packagePlatforms pkgs.pkgsCross.ghcjs.haskellPackages)
                  ghc
                  hello
                  microlens
                  ;
              };

              haskell.packages.ghc912 = {
                inherit (packagePlatforms pkgs.pkgsCross.ghcjs.haskell.packages.ghc912)
                  ghc
                  hello
                  microlens
                  miso
                  reflex-dom
                  ;
              };

              haskell.packages.ghcHEAD = {
                inherit (packagePlatforms pkgs.pkgsCross.ghcjs.haskell.packages.ghcHEAD)
                  ghc
                  hello
                  microlens
                  ;
              };
            };

        ucrt64.haskell.packages.ghc912 = {
          inherit (packagePlatforms pkgs.pkgsCross.ucrt64.haskell.packages.ghc912)
            ghc
            # hello # executables don't build yet
            microlens
            ;
        };

        riscv64 = {
          # Cross compilation of GHC
          haskell.compiler = {
            inherit (packagePlatforms pkgs.pkgsCross.riscv64.haskell.compiler)
              # Latest GHC we are able to cross-compile.
              ghc948
              ;
          };
        };

        aarch64-multiplatform = {
          # Cross compilation of GHC
          haskell.compiler = {
            inherit (packagePlatforms pkgs.pkgsCross.aarch64-multiplatform.haskell.compiler)
              # Latest GHC we are able to cross-compile. Uses NCG backend.
              ghc948
              ;
          };
        };
      };
    })
    (versionedCompilerJobs {
      # Packages which should be checked on more than the
      # default GHC version. This list can be used to test
      # the state of the package set with newer compilers
      # and to confirm that critical packages for the
      # package sets (like Cabal, jailbreak-cabal) are
      # working as expected.
      cabal-install = lib.subtractLists [
        # It is recommended to use pkgs.cabal-install instead of cabal-install
        # from the package sets. Due to (transitively) requiring recent versions
        # of core packages, it is not always reasonable to get cabal-install to
        # work with older compilers.
        compilerNames.ghc948
      ] released;
      Cabal_3_10_3_0 = lib.subtractLists [
        # time < 1.13 conflicts with time == 1.14.*
        compilerNames.ghc9122
      ] released;
      Cabal_3_12_1_0 = released;
      Cabal_3_14_2_0 = released;
      Cabal_3_16_0_0 = released;
      cabal2nix = released;
      cabal2nix-unstable = released;
      funcmp = released;
      git-annex = [
        # for 9.10, test that using filepath (instead of filepath-bytestring) works.
        compilerNames.ghc9102
        compilerNames.ghc9103
      ];
      haskell-language-server = released;
      hoogle = released;
      hlint = lib.subtractLists [
        compilerNames.ghc9102
        compilerNames.ghc9103
        compilerNames.ghc9122
      ] released;
      hpack = released;
      hsdns = released;
      jailbreak-cabal = released;
      language-nix = released;
      nix-paths = released;
      titlecase = released;
      ghc-lib = released;
      ghc-lib-parser = released;
      ghc-lib-parser-ex = released;
      ghc-source-gen = lib.subtractLists [
        compilerNames.ghc9122
      ] released;
      ghc-tags = lib.subtractLists [
        compilerNames.ghc9122
      ] released;
      hashable = released;
      primitive = released;
      semaphore-compat = [
        # Compiler < 9.8 don't have the semaphore-compat core package, but
        # requires unix >= 2.8.1.0 which implies GHC >= 9.6 for us.
        compilerNames.ghc967
      ];
      weeder = lib.subtractLists [
        compilerNames.ghc9102
        compilerNames.ghc9103
        compilerNames.ghc9122
      ] released;
    })
    {
      mergeable = pkgs.releaseTools.aggregate {
        name = "haskell-updates-mergeable";
        meta = {
          description = ''
            Critical haskell packages that should work at all times,
            serves as minimum requirement for an update merge
          '';
          teams = [ lib.teams.haskell ];
        };
        constituents = accumulateDerivations [
          # haskell specific tests
          jobs.tests.haskell
          # important top-level packages
          jobs.cabal-install
          jobs.cabal2nix
          jobs.cachix
          jobs.darcs
          jobs.haskell-language-server
          jobs.hledger
          jobs.hledger-ui
          jobs.hpack
          jobs.niv
          jobs.pandoc
          jobs.stack
          jobs.stylish-haskell
          jobs.shellcheck
          # important haskell (library) packages
          jobs.haskellPackages.cabal-plan
          jobs.haskellPackages.distribution-nixpkgs
          jobs.haskellPackages.hackage-db
          jobs.haskellPackages.xmonad
          jobs.haskellPackages.xmonad-contrib
          # haskell packages maintained by @peti
          # imported from the old hydra jobset
          jobs.haskellPackages.hopenssl
          jobs.haskellPackages.hsemail
          jobs.haskellPackages.hsyslog
        ];
      };
      maintained = pkgs.releaseTools.aggregate {
        name = "maintained-haskell-packages";
        meta = {
          description = "Aggregate jobset of all haskell packages with a maintainer";
          teams = [ lib.teams.haskell ];
        };
        constituents = accumulateDerivations (
          map (name: jobs.haskellPackages."${name}") (maintainedPkgNames pkgs.haskellPackages)
        );
      };

      muslGHCs = pkgs.releaseTools.aggregate {
        name = "haskell-pkgsMusl-ghcs";
        meta = {
          description = "GHCs built with musl";
          maintainers = with lib.maintainers; [
            nh2
          ];
        };
        constituents = accumulateDerivations [
          jobs.pkgsMusl.haskell.compiler.ghcHEAD
          jobs.pkgsMusl.haskell.compiler.native-bignum.ghcHEAD
        ];
      };

      staticHaskellPackages = pkgs.releaseTools.aggregate {
        name = "static-haskell-packages";
        meta = {
          description = "Static haskell builds using the pkgsStatic infrastructure";
          maintainers = [
            lib.maintainers.sternenseemann
            lib.maintainers.rnhmjoj
          ];
        };
        constituents = accumulateDerivations [
          jobs.pkgsStatic.haskell.packages.native-bignum.ghc948 # non-hadrian
          jobs.pkgsStatic.haskellPackages
          jobs.pkgsStatic.haskell.packages.native-bignum.ghc9103
        ];
      };
    }
  ];

in
jobs
