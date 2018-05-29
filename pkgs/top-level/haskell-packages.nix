{ buildPackages, pkgs
, newScope, stdenv
, buildPlatform, targetPlatform
}:

let
  # These are attributes in compiler and packages that don't support integer-simple.
  integerSimpleExcludes = [
    "ghc704Binary"
    "ghc742Binary"
    "ghc784Binary"
    "ghc7103Binary"
    "ghc821Binary"
    "ghc704"
    "ghc763"
    "ghcjs"
    "ghcjsHEAD"
    "ghcCross"
    "integer-simple"
  ];

  haskellLib = import ../development/haskell-modules/lib.nix {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  callPackage = newScope { inherit haskellLib; };

in rec {
  lib = haskellLib;

  compiler = {

    ghc704Binary = callPackage ../development/compilers/ghc/7.0.4-binary.nix { gmp = pkgs.gmp4; };
    ghc742Binary = callPackage ../development/compilers/ghc/7.4.2-binary.nix { gmp = pkgs.gmp4; };
    ghc784Binary = callPackage ../development/compilers/ghc/7.8.4-binary.nix { };
    ghc7103Binary = callPackage ../development/compilers/ghc/7.10.3-binary.nix { };
    ghc821Binary = callPackage ../development/compilers/ghc/8.2.1-binary.nix { };

    ghc704 = callPackage ../development/compilers/ghc/7.0.4.nix {
      ghc = compiler.ghc704Binary;
    };
    ghc742 = callPackage ../development/compilers/ghc/7.4.2.nix {
      ghc = compiler.ghc704Binary;
    };
    ghc763 = callPackage ../development/compilers/ghc/7.6.3.nix {
      ghc = compiler.ghc704Binary;
    };
    ghc784 = callPackage ../development/compilers/ghc/7.8.4.nix {
      ghc = compiler.ghc742Binary;
    };
    ghc7103 = callPackage ../development/compilers/ghc/7.10.3.nix rec {
      bootPkgs = packages.ghc7103Binary;
      inherit (bootPkgs) hscolour;
      buildLlvmPackages = buildPackages.llvmPackages_35;
      llvmPackages = pkgs.llvmPackages_35;
    };
    ghc802 = callPackage ../development/compilers/ghc/8.0.2.nix rec {
      bootPkgs = packages.ghc7103Binary;
      inherit (bootPkgs) hscolour;
      sphinx = pkgs.python27Packages.sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_37;
      llvmPackages = pkgs.llvmPackages_37;
    };
    ghc822 = callPackage ../development/compilers/ghc/8.2.2.nix rec {
      bootPkgs = packages.ghc821Binary;
      inherit (bootPkgs) hscolour alex happy;
      inherit buildPlatform targetPlatform;
      sphinx = pkgs.python3Packages.sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_39;
      llvmPackages = pkgs.llvmPackages_39;
    };
    ghc841 = callPackage ../development/compilers/ghc/8.4.1.nix rec {
      bootPkgs = packages.ghc821Binary;
      inherit (bootPkgs) alex happy;
      buildLlvmPackages = buildPackages.llvmPackages_5;
      llvmPackages = pkgs.llvmPackages_5;
    };
    ghc843 = callPackage ../development/compilers/ghc/8.4.3.nix rec {
      bootPkgs = packages.ghc821Binary;
      inherit (bootPkgs) alex happy hscolour;
      buildLlvmPackages = buildPackages.llvmPackages_5;
      llvmPackages = pkgs.llvmPackages_5;
    };
    ghcHEAD = callPackage ../development/compilers/ghc/head.nix rec {
      bootPkgs = packages.ghc821Binary;
      inherit (bootPkgs) alex happy;
      buildLlvmPackages = buildPackages.llvmPackages_5;
      llvmPackages = pkgs.llvmPackages_5;
    };
    ghcjs = packages.ghc7103.callPackage ../development/compilers/ghcjs {
      bootPkgs = packages.ghc7103;
      inherit (pkgs) cabal-install;
    };
    ghcjsHEAD = packages.ghc802.callPackage ../development/compilers/ghcjs/head.nix {
      bootPkgs = packages.ghc802;
      inherit (pkgs) cabal-install;
    };

    # The integer-simple attribute set contains all the GHC compilers
    # build with integer-simple instead of integer-gmp.
    integer-simple = let
      integerSimpleGhcNames = pkgs.lib.filter
        (name: ! builtins.elem name integerSimpleExcludes)
        (pkgs.lib.attrNames compiler);
    in pkgs.recurseIntoAttrs (pkgs.lib.genAttrs
      integerSimpleGhcNames
      (name: compiler."${name}".override { enableIntegerSimple = true; }));
  };

  # Always get compilers from `buildPackages`
  packages = let bh = buildPackages.haskell; in {

    ghc7103 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc7103;
      ghc = bh.compiler.ghc7103;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-7.10.x.nix { };
    };
    ghc7103Binary = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc7103Binary;
      ghc = bh.compiler.ghc7103Binary;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-7.10.x.nix { };
    };
    ghc802 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc802;
      ghc = bh.compiler.ghc802;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.0.x.nix { };
    };
    ghc821Binary = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc821Binary;
      ghc = bh.compiler.ghc821Binary;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.2.x.nix { };
    };
    ghc822 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc822;
      ghc = bh.compiler.ghc822;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.2.x.nix { };
    };
    ghc841 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc841;
      ghc = bh.compiler.ghc841;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.4.x.nix { };
    };
    ghc843 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc843;
      ghc = bh.compiler.ghc843;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.4.x.nix { };
    };
    ghcHEAD = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghcHEAD;
      ghc = bh.compiler.ghcHEAD;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-head.nix { };
    };
    ghcjs = callPackage ../development/haskell-modules rec {
      buildHaskellPackages = ghc.bootPkgs;
      ghc = bh.compiler.ghcjs;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-7.10.x.nix { };
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghcjs.nix { };
    };
    ghcjsHEAD = callPackage ../development/haskell-modules rec {
      buildHaskellPackages = ghc.bootPkgs;
      ghc = bh.compiler.ghcjsHEAD;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.0.x.nix { };
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghcjs.nix { };
    };

    # The integer-simple attribute set contains package sets for all the GHC compilers
    # using integer-simple instead of integer-gmp.
    integer-simple = let
      integerSimpleGhcNames = pkgs.lib.filter
        (name: ! builtins.elem name integerSimpleExcludes)
        (pkgs.lib.attrNames packages);
    in pkgs.lib.genAttrs integerSimpleGhcNames (name: packages."${name}".override {
      ghc = compiler.integer-simple."${name}";
      overrides = _self : _super : {
        integer-simple = null;
        integer-gmp = null;
      };
    });

  };
}
