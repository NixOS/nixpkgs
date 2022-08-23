/*
  This is the Hydra jobset for the `haskell-updates` branch in Nixpkgs.
  You can see the status of this jobset at
  https://hydra.nixos.org/jobset/nixpkgs/haskell-updates.

  To debug this expression you can use `hydra-eval-jobs` from
  `pkgs.hydra_unstable` which prints the jobset description
  to `stdout`:

  $ hydra-eval-jobs -I . pkgs/top-level/release-haskell.nix
*/
{ supportedSystems ? [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" ] }:

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
        else if lib.isAttrs attrs
        then accumulateDerivations (lib.attrValues attrs)
        else []
    ) jobList;

  # names of all subsets of `pkgs.haskell.packages`
  compilerNames = lib.mapAttrs (name: _: name) pkgs.haskell.packages;

  # list of all compilers to test specific packages on
  released = with compilerNames; [
    ghc884
    ghc8107
    ghc902
    ghc924
  ];

  # packagePlatforms applied to `haskell.packages.*`
  compilerPlatforms = lib.mapAttrs
    (_: v: packagePlatforms v)
    pkgs.haskell.packages;

  # This function lets you specify specific packages
  # which are to be tested on a list of specific GHC
  # versions and returns a job set for all specified
  # combinations. See `jobs` below for an example.
  versionedCompilerJobs = config: mapTestOn {
    haskell.packages =
      (lib.mapAttrs (
        ghc: jobs:
        lib.filterAttrs (
          jobName: platforms:
          lib.elem ghc (config."${jobName}" or [])
        ) jobs
      ) compilerPlatforms);
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
        bustle
        blucontrol
        cabal-install
        cabal2nix
        cachix
        carp
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
        # hyper-haskell  # depends on electron-10.4.7 which is marked as insecure
        hyper-haskell-server-with-packages
        icepeak
        idris
        ihaskell
        jacinda
        jl
        koka
        krank
        lambdabot
        lhs2tex
        madlang
        matterhorn
        mueval
        naproche
        neuron-notes
        niv
        nix-delegate
        nix-deploy
        nix-diff
        nix-linter
        nix-output-monitor
        nix-script
        nix-tree
        nixfmt
        nota
        nvfetcher
        ormolu
        pandoc
        pakcs
        petrinizer
        place-cursor-at
        pinboard-notes-backup
        pretty-simple
        shake
        shellcheck
        sourceAndTags
        spacecookie
        spago
        splot
        stack
        stack2nix
        stutter
        stylish-haskell
        taffybar
        tamarin-prover
        taskell
        termonad-with-packages
        tldr-hs
        tweet-hs
        update-nix-fetchgit
        uusi
        uqm
        uuagc
        vaultenv
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
          elmi-to-json
          ;
      };

      # GHCs linked to musl.
      pkgsMusl.haskell.compiler = lib.recursiveUpdate
        (packagePlatforms pkgs.pkgsMusl.haskell.compiler)
        {
          # remove musl ghc865Binary since it is known to be broken and
          # causes an evaluation error on darwin.
          # TODO: remove ghc865Binary altogether and use ghc8102Binary
          ghc865Binary = {};

          ghcjs = {};
          ghcjs810 = {};

          # Can't be built with musl, see meta.broken comment in the drv
          integer-simple.ghc884 = {};
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
      # Use integer-simple to avoid GMP linking problems (LGPL)
      pkgsStatic =
        removePlatforms
          [
            "aarch64-linux" # times out on Hydra
            "x86_64-darwin" # TODO: reenable when static libiconv works on darwin
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

            haskell.packages.native-bignum.ghc924 = {
              inherit (packagePlatforms pkgs.pkgsStatic.haskell.packages.native-bignum.ghc924)
                hello
                lens
                random
                QuickCheck
                cabal2nix
                terminfo # isn't bundled for cross
                xhtml # isn't bundled for cross
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
      cabal-install = released;
      Cabal_3_6_3_0 = released;
      cabal2nix = released;
      cabal2nix-unstable = released;
      funcmp = released;
      haskell-language-server = released;
      hoogle = released;
      hlint = released;
      hsdns = released;
      jailbreak-cabal = released;
      language-nix = released;
      nix-paths = released;
      titlecase = released;
      ghc-api-compat = [
        compilerNames.ghc884
        compilerNames.ghc8107
        compilerNames.ghc902
      ];
      ghc-bignum = [
        compilerNames.ghc884
        compilerNames.ghc8107
      ];
      ghc-lib = released;
      ghc-lib-parser = released;
      ghc-lib-parser-ex = released;
      spectacle = [
        compilerNames.ghc8107
      ];
      weeder = [
        compilerNames.ghc8107
        compilerNames.ghc902
        compilerNames.ghc924
      ];
      purescript-cst = [
        compilerNames.ghc8107
      ];
      purescript-ast = [
        compilerNames.ghc8107
      ];
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
          jobs.pkgsMusl.haskell.compiler.ghc8102Binary
          jobs.pkgsMusl.haskell.compiler.ghc8107Binary
          jobs.pkgsMusl.haskell.compiler.ghc884
          jobs.pkgsMusl.haskell.compiler.ghc8107
          jobs.pkgsMusl.haskell.compiler.ghc902
          jobs.pkgsMusl.haskell.compiler.ghc924
          jobs.pkgsMusl.haskell.compiler.ghcHEAD
          jobs.pkgsMusl.haskell.compiler.integer-simple.ghc8107
          jobs.pkgsMusl.haskell.compiler.native-bignum.ghc902
          jobs.pkgsMusl.haskell.compiler.native-bignum.ghc924
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
          jobs.pkgsStatic.haskellPackages
          jobs.pkgsStatic.haskell.packages.native-bignum.ghc924
        ];
      };
    }
  ];

in jobs
