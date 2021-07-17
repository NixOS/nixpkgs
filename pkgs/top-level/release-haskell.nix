/*
  This is the Hydra jobset for the `haskell-updates` branch in Nixpkgs.
  You can see the status of this jobset at
  https://hydra.nixos.org/jobset/nixpkgs/haskell-updates.

  To debug this expression you can use `hydra-eval-jobs` from
  `pkgs.hydra-unstable` which prints the jobset description
  to `stdout`:

  $ hydra-eval-jobs -I . pkgs/top-level/release-haskell.nix
*/
{ supportedSystems ? [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" ] }:

let

  releaseLib = import ./release-lib.nix {
    inherit supportedSystems;
  };

  inherit (releaseLib)
    pkgs
    packagePlatforms
    mapTestOn
    aggregate
    ;

  inherit (pkgs) lib;

  # helper function which traverses a (nested) set
  # of derivations produced by mapTestOn and flattens
  # it to a list of derivations suitable to be passed
  # to `releaseTools.aggregate` as constituents.
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
  all = with compilerNames; [
    ghc884
    ghc8104
    ghc901
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

  staticHaskellPackagesPlatforms =
    packagePlatforms pkgs.pkgsStatic.haskell.packages.integer-simple.ghc8104;

  jobs = recursiveUpdateMany [
    (mapTestOn {
      haskellPackages = packagePlatforms pkgs.haskellPackages;
      haskell.compiler = packagePlatforms pkgs.haskell.compiler;

      tests.haskell = packagePlatforms pkgs.tests.haskell;

      pkgsMusl.haskell.compiler = packagePlatforms pkgs.pkgsMusl.haskell.compiler // {
        # remove musl ghc865Binary since it is known to be broken and
        # causes an evaluation error on darwin.
        # TODO: remove ghc865Binary altogether and use ghc8102Binary
        ghc865Binary = {};
      };

      # test some statically linked packages to catch regressions
      # and get some cache going for static compilation with GHC
      # Use integer-simple to avoid GMP linking problems (LGPL)
      pkgsStatic.haskell.packages.integer-simple.ghc8104 = {
        inherit (staticHaskellPackagesPlatforms)
          hello
          random
          lens
          ;
      };

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
        dhall-text
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
        hledger-iadd
        hledger-interest
        hledger-ui
        hledger-web
        hlint
        hpack
        hyper-haskell
        hyper-haskell-server-with-packages
        icepeak
        idris
        ihaskell
        jl
        koka
        krank
        lambdabot
        madlang
        matterhorn
        mueval
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
        xmonad-with-packages
        yi
        zsh-git-prompt
        ;

      elmPackages.elm = pkgsPlatforms.elmPackages.elm;
    })
    (versionedCompilerJobs {
      # Packages which should be checked on more than the
      # default GHC version. This list can be used to test
      # the state of the package set with newer compilers
      # and to confirm that critical packages for the
      # package sets (like Cabal, jailbreak-cabal) are
      # working as expected.
      cabal-install = all;
      Cabal_3_4_0_0 = with compilerNames; [ ghc884 ghc8104 ];
      cabal2nix-unstable = all;
      funcmp = all;
      # Doesn't currently work on ghc-9.0:
      # https://github.com/haskell/haskell-language-server/issues/297
      haskell-language-server = with compilerNames; [ ghc884 ghc8104 ];
      hoogle = all;
      hsdns = all;
      jailbreak-cabal = all;
      language-nix = all;
      nix-paths = all;
      titlecase = all;
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
          #
          # TODO: The writers test appears to be failing on darwin for unknown
          # reasons.  See https://github.com/NixOS/nixpkgs/pull/129606#issuecomment-881307871.
          (lib.recursiveUpdate jobs.tests.haskell { writers.x86_64-darwin = null; })
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
          jobs.haskellPackages.policeman
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
      staticHaskellPackages = pkgs.releaseTools.aggregate {
        name = "static-haskell-packages";
        meta = {
          description = "Static haskell builds using the pkgsStatic infrastructure";
          maintainers = [
            lib.maintainers.sternenseemann
            lib.maintainers.rnhmjoj
          ];
        };
        constituents = [
          # TODO: reenable darwin builds if static libiconv works
          jobs.pkgsStatic.haskell.packages.integer-simple.ghc8104.hello.x86_64-linux
          jobs.pkgsStatic.haskell.packages.integer-simple.ghc8104.hello.aarch64-linux
          jobs.pkgsStatic.haskell.packages.integer-simple.ghc8104.lens.x86_64-linux
          jobs.pkgsStatic.haskell.packages.integer-simple.ghc8104.lens.aarch64-linux
          jobs.pkgsStatic.haskell.packages.integer-simple.ghc8104.random.x86_64-linux
          jobs.pkgsStatic.haskell.packages.integer-simple.ghc8104.random.aarch64-linux
        ];
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
          jobs.pkgsMusl.haskell.compiler.ghc884
          jobs.pkgsMusl.haskell.compiler.ghc8104
          jobs.pkgsMusl.haskell.compiler.ghc901
        ];
      };
    }
  ];

in jobs
