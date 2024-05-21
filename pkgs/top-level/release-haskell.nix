/*
  This is the Hydra jobset for the `haskell-updates` branch in Nixpkgs.
  You can see the status of this jobset at
  https://hydra.nixos.org/jobset/nixpkgs/haskell-updates.

  To debug this expression you can use `hydra-eval-jobs` from
  `pkgs.hydra_unstable` which prints the jobset description
  to `stdout`:

  $ hydra-eval-jobs -I . pkgs/top-level/release-haskell.nix
*/
{ supportedSystems ? [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ] }:

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
  accumulateDerivations = jobList:
    lib.concatMap (
      attrs:
        if lib.isDerivation attrs
        then [ attrs ]
        else lib.optionals (lib.isAttrs attrs) (accumulateDerivations (lib.attrValues attrs))
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
    ghc8107
    ghc902
    ghc925
    ghc926
    ghc927
    ghc928
    ghc945
    ghc946
    ghc947
    ghc948
    ghc963
    ghc964
    ghc965
    ghc981
    ghc982
    ghc9101
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
  compilerPlatforms = lib.mapAttrs
    (_: v: packagePlatforms v)
    pkgs.haskell.packages;

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
  versionedCompilerJobs = config: mapTestOn {
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
        onlyConfigJobs = ghc: jobs:
          let
            configFilteredJobset =
              lib.filterAttrs
                (jobName: platforms: lib.elem ghc (config."${jobName}" or []))
                jobs;

            # Remove platforms from each job that are not supported by GHC.
            # This is important so that we don't build jobs for platforms
            # where GHC can't be compiled.
            jobsetWithGHCPlatforms =
              lib.mapAttrs
                (_: platforms: lib.intersectLists jobs.ghc platforms)
                configFilteredJobset;
          in
          jobsetWithGHCPlatforms;
      in
      lib.mapAttrs onlyConfigJobs compilerPlatforms;
  };

  # hydra jobs for `pkgs` of which we import a subset of
  pkgsPlatforms = packagePlatforms pkgs;

  # names of packages in an attribute set that are maintained
  maintainedPkgNames = set: builtins.attrNames
    (lib.filterAttrs (
      _: v: builtins.length (v.meta.maintainers or []) > 0
    ) set);

  recursiveUpdateMany = builtins.foldl' lib.recursiveUpdate {};

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
  removePlatforms = platformsToRemove: packageSet:
    lib.mapAttrsRecursive
      (_: val:
        if lib.isList val
          then removeMany platformsToRemove val
          else val
      )
      packageSet;

  jobs = recursiveUpdateMany [
    (mapTestOn {
      haskellPackages = packagePlatforms pkgs.haskellPackages;
      haskell.compiler = packagePlatforms pkgs.haskell.compiler // (lib.genAttrs [
        "ghcjs"
        "ghcjs810"
      ] (ghcjsName: {
        # We can't build ghcjs itself, since it exceeds 3GB (Hydra's output limit) due
        # to the size of its bundled libs. We can however save users a bit of compile
        # time by building the bootstrap ghcjs on Hydra. For this reason, we overwrite
        # the ghcjs attributes in haskell.compiler with a reference to the bootstrap
        # ghcjs attribute in their bootstrap package set (exposed via passthru) which
        # would otherwise be ignored by Hydra.
        bootGhcjs = (packagePlatforms pkgs.haskell.compiler.${ghcjsName}.passthru).bootGhcjs;
      }));

      tests.haskell = packagePlatforms pkgs.tests.haskell;

      nixosTests = {
        inherit (packagePlatforms pkgs.nixosTests)
          agda
          xmonad
          xmonad-xdg-autostart
        ;
      };

      agdaPackages = packagePlatforms pkgs.agdaPackages;

      # top-level packages that depend on haskellPackages
      inherit (pkgsPlatforms)
        agda
        arion
        bench
        blucontrol
        cabal-install
        cabal2nix
        cachix
        # carp broken on 2024-04-09
        cedille
        client-ip-echo
        darcs
        dconf2nix
        dhall
        dhall-bash
        dhall-docs
        dhall-lsp-server
        dhall-json
        dhall-nix
        diagrams-builder
        elm2nix
        emanote
        fffuu
        futhark
        ghcid
        git-annex
        git-brunch
        gitit
        glirc
        hadolint
        haskell-ci
        haskell-language-server
        hasura-graphql-engine
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
        icepeak
        ihaskell
        jacinda
        jl
        koka
        krank
        lambdabot
        lhs2tex
        madlang
        mailctl
        matterhorn
        mkjson
        mueval
        naproche
        niv
        nix-delegate
        nix-deploy
        nix-diff
        nix-linter
        nix-output-monitor
        nix-script
        nix-tree
        nixfmt
        nixfmt-classic
        nixfmt-rfc-style
        nota
        nvfetcher
        ormolu
        # pakcs broken by set-extra on 2024-03-15
        pandoc
        petrinizer
        place-cursor-at
        pinboard-notes-backup
        pretty-simple
        shake
        shellcheck
        sourceAndTags
        spacecookie
        spago
        specup
        splot
        stack
        stack2nix
        stutter
        stylish-haskell
        taffybar
        tamarin-prover
        taskell
        termonad
        tldr-hs
        tweet-hs
        update-nix-fetchgit
        uusi
        uqm
        uuagc
        # vaultenv: broken by connection on 2024-03-16
        wstunnel
        xmobar
        xmonadctl
        xmonad-with-packages
        yi
        zsh-git-prompt
        ;

      # Members of the elmPackages set that are Haskell derivations
      elmPackages = {
        inherit (pkgsPlatforms.elmPackages)
          elm
          elm-format
          elm-instrument
          # elmi-to-json broken by hashable-time on 2024-03-16
          ;
      };

      # GHCs linked to musl.
      pkgsMusl.haskell.compiler = lib.recursiveUpdate
        (packagePlatforms pkgs.pkgsMusl.haskell.compiler)
        {
          # remove musl ghc865Binary since it is known to be broken and
          # causes an evaluation error on darwin.
          ghc865Binary = {};

          ghcjs = {};
          ghcjs810 = {};
        };

      # Get some cache going for MUSL-enabled GHC.
      pkgsMusl.haskellPackages =
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
            inherit (packagePlatforms pkgs.pkgsMusl.haskellPackages)
              hello
              lens
              random
              ;
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
          ] {
            haskellPackages = {
              inherit (packagePlatforms pkgs.pkgsStatic.haskellPackages)
                hello
                lens
                random
                QuickCheck
                cabal2nix
                terminfo # isn't bundled for cross
                xhtml # isn't bundled for cross
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
              ;
            };

            haskell.packages.native-bignum.ghc982 = {
              inherit (packagePlatforms pkgs.pkgsStatic.haskell.packages.native-bignum.ghc982)
                hello
                random
                QuickCheck
                terminfo # isn't bundled for cross
                ;
            };
          };

      pkgsCross.ghcjs =
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

            haskell.packages.ghc98 = {
              inherit (packagePlatforms pkgs.pkgsCross.ghcjs.haskell.packages.ghc98)
                ghc
                hello
                microlens
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
    })
    (versionedCompilerJobs {
      # Packages which should be checked on more than the
      # default GHC version. This list can be used to test
      # the state of the package set with newer compilers
      # and to confirm that critical packages for the
      # package sets (like Cabal, jailbreak-cabal) are
      # working as expected.
      cabal-install = lib.subtractLists [
        compilerNames.ghc981
        compilerNames.ghc982
        compilerNames.ghc9101
      ] released;
      Cabal_3_10_3_0 = lib.subtractLists [
        compilerNames.ghc981
        compilerNames.ghc982
        compilerNames.ghc9101
      ] released;
      Cabal-syntax_3_10_3_0 = lib.subtractLists [
        compilerNames.ghc981
        compilerNames.ghc982
        compilerNames.ghc9101
      ] released;
      cabal2nix = lib.subtractLists [
        compilerNames.ghc981
        compilerNames.ghc982
        compilerNames.ghc9101
      ] released;
      cabal2nix-unstable = lib.subtractLists [
        compilerNames.ghc981
        compilerNames.ghc982
        compilerNames.ghc9101
      ] released;
      funcmp = released;
      haskell-language-server = lib.subtractLists [
        # Support ceased as of 2.3.0.0
        compilerNames.ghc8107
        # Support ceased as of 2.5.0.0
        compilerNames.ghc902
        # No support yet (2024-05-12)
        compilerNames.ghc9101
      ] released;
      hoogle = lib.subtractLists [
        compilerNames.ghc981
        compilerNames.ghc982
        compilerNames.ghc9101
      ] released;
      hlint = lib.subtractLists [
        compilerNames.ghc902
        compilerNames.ghc981
        compilerNames.ghc982
        compilerNames.ghc9101
      ] released;
      hpack = lib.subtractLists [
        compilerNames.ghc981
        compilerNames.ghc982
        compilerNames.ghc9101
      ] released;
      hsdns = released;
      jailbreak-cabal = released;
      language-nix = lib.subtractLists [
        compilerNames.ghc981
        compilerNames.ghc982
        compilerNames.ghc9101
      ] released;
      large-hashable = [
        compilerNames.ghc928
      ];
      nix-paths = released;
      titlecase = lib.subtractLists [
        compilerNames.ghc981
        compilerNames.ghc982
        compilerNames.ghc9101
      ] released;
      ghc-api-compat = [
        compilerNames.ghc8107
        compilerNames.ghc902
      ];
      ghc-bignum = [
        compilerNames.ghc8107
      ];
      ghc-lib = lib.subtractLists [
        compilerNames.ghc981
        compilerNames.ghc982
        compilerNames.ghc9101
      ] released;
      ghc-lib-parser = lib.subtractLists [
        compilerNames.ghc981
        compilerNames.ghc982
        compilerNames.ghc9101
      ] released;
      ghc-lib-parser-ex = lib.subtractLists [
        compilerNames.ghc981
        compilerNames.ghc982
        compilerNames.ghc9101
      ] released;
      ghc-source-gen = [
        # Feel free to remove these as they break,
        # ghc-source-gen currently doesn't support GHC 9.4
        compilerNames.ghc8107
        compilerNames.ghc902
        compilerNames.ghc928
      ];
      # broken on 2024-03-16
      # ghc-tags = lib.subtractLists [
      #   compilerNames.ghc981
      #   compilerNames.ghc982
      # ] released;
      hashable = lib.subtractLists [
        compilerNames.ghc981
        compilerNames.ghc982
        compilerNames.ghc9101
      ] released;
      primitive = lib.subtractLists [
        compilerNames.ghc9101
      ] released;
      weeder = lib.subtractLists [
        compilerNames.ghc981
        compilerNames.ghc982
        compilerNames.ghc9101
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
          maintainers = lib.teams.haskell.members;
        };
        constituents =
          accumulateDerivations [
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
          maintainers = lib.teams.haskell.members;
        };
        constituents = accumulateDerivations
          (builtins.map
            (name: jobs.haskellPackages."${name}")
            (maintainedPkgNames pkgs.haskellPackages));
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
          jobs.pkgsMusl.haskell.compiler.ghc8107Binary
          jobs.pkgsMusl.haskell.compiler.ghc8107
          jobs.pkgsMusl.haskell.compiler.ghc902
          jobs.pkgsMusl.haskell.compiler.ghc925
          jobs.pkgsMusl.haskell.compiler.ghc926
          jobs.pkgsMusl.haskell.compiler.ghc927
          jobs.pkgsMusl.haskell.compiler.ghc928
          jobs.pkgsMusl.haskell.compiler.ghcHEAD
          jobs.pkgsMusl.haskell.compiler.integer-simple.ghc8107
          jobs.pkgsMusl.haskell.compiler.native-bignum.ghc902
          jobs.pkgsMusl.haskell.compiler.native-bignum.ghc925
          jobs.pkgsMusl.haskell.compiler.native-bignum.ghc926
          jobs.pkgsMusl.haskell.compiler.native-bignum.ghc927
          jobs.pkgsMusl.haskell.compiler.native-bignum.ghc928
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
          jobs.pkgsStatic.haskell.packages.native-bignum.ghc982
        ];
      };
    }
  ];

in jobs
