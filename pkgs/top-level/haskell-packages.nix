{ buildPackages, pkgs
, newScope
}:

let
  # These are attributes in compiler and packages that don't support integer-simple.
  integerSimpleExcludes = [
    "ghc7103Binary"
    "ghc821Binary"
    "ghcjs"
    "ghcjs710"
    "ghcjs80"
    "ghcjs82"
    "ghcjs84"
    "integer-simple"
  ];

  haskellLib = import ../development/haskell-modules/lib.nix {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  callPackage = newScope {
    inherit haskellLib;
    overrides = pkgs.haskell.packageOverrides;
  };

  bootstrapPackageSet = self: super: {
    mkDerivation = drv: super.mkDerivation (drv // {
      doCheck = false;
      doHaddock = false;
      enableExecutableProfiling = false;
      enableLibraryProfiling = false;
      enableSharedExecutables = false;
      enableSharedLibraries = false;
    });
  };

in rec {
  lib = haskellLib;

  compiler = {

    ghc7103Binary = callPackage ../development/compilers/ghc/7.10.3-binary.nix { };
    ghc821Binary = callPackage ../development/compilers/ghc/8.2.1-binary.nix { };

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
      sphinx = pkgs.python3Packages.sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_39;
      llvmPackages = pkgs.llvmPackages_39;
    };
    ghc843 = callPackage ../development/compilers/ghc/8.4.3.nix rec {
      bootPkgs = packages.ghc821Binary;
      inherit (bootPkgs) alex happy hscolour;
      buildLlvmPackages = buildPackages.llvmPackages_5;
      llvmPackages = pkgs.llvmPackages_5;
    };
    ghc861 = callPackage ../development/compilers/ghc/8.6.1.nix rec {
      bootPkgs = packages.ghc822;
      inherit (bootPkgs) alex happy hscolour;
      buildLlvmPackages = buildPackages.llvmPackages_6;
      llvmPackages = pkgs.llvmPackages_6;
    };
    ghcHEAD = callPackage ../development/compilers/ghc/head.nix rec {
      bootPkgs = packages.ghc821Binary;
      inherit (bootPkgs) alex happy hscolour;
      buildLlvmPackages = buildPackages.llvmPackages_5;
      llvmPackages = pkgs.llvmPackages_5;
    };
    ghcjs = compiler.ghcjs84;
    ghcjs710 = packages.ghc7103.callPackage ../development/compilers/ghcjs {
      bootPkgs = packages.ghc7103;
      inherit (pkgs) cabal-install;
    };
    ghcjs80 = packages.ghc802.callPackage ../development/compilers/ghcjs/head.nix {
      bootPkgs = packages.ghc802;
      inherit (pkgs) cabal-install;
    };
    ghcjs82 = callPackage ../development/compilers/ghcjs-ng rec {
      bootPkgs = packages.ghc822;
      inherit (bootPkgs) alex happy;
      ghcjsSrcJson = ../development/compilers/ghcjs-ng/8.2/git.json;
      stage0 = ../development/compilers/ghcjs-ng/8.2/stage0.nix;
    };
    ghcjs84 = callPackage ../development/compilers/ghcjs-ng rec {
      bootPkgs = packages.ghc843;
      inherit (bootPkgs) alex happy;
      ghcjsSrcJson = ../development/compilers/ghcjs-ng/8.4/git.json;
      stage0 = ../development/compilers/ghcjs-ng/8.4/stage0.nix;
      ghcjsDepOverrides = callPackage ../development/compilers/ghcjs-ng/8.4/dep-overrides.nix {};
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

  # Default overrides that are applied to all package sets.
  packageOverrides = self : super : {};

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
      packageSetConfig = bootstrapPackageSet;
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
      packageSetConfig = bootstrapPackageSet;
    };
    ghc822 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc822;
      ghc = bh.compiler.ghc822;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.2.x.nix { };
    };
    ghc843 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc843;
      ghc = bh.compiler.ghc843;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.4.x.nix { };
    };
    ghc861 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc861;
      ghc = bh.compiler.ghc861;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.6.x.nix { };
    };
    ghcHEAD = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghcHEAD;
      ghc = bh.compiler.ghcHEAD;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-head.nix { };
    };
    ghcjs = packages.ghcjs84;
    ghcjs710 = callPackage ../development/haskell-modules rec {
      buildHaskellPackages = ghc.bootPkgs;
      ghc = bh.compiler.ghcjs710;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-7.10.x.nix { };
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghcjs.nix { };
    };
    ghcjs80 = callPackage ../development/haskell-modules rec {
      buildHaskellPackages = ghc.bootPkgs;
      ghc = bh.compiler.ghcjs80;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.0.x.nix { };
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghcjs.nix { };
    };
    ghcjs82 = callPackage ../development/haskell-modules rec {
      buildHaskellPackages = ghc.bootPkgs;
      ghc = bh.compiler.ghcjs82;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.2.x.nix { };
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghcjs.nix { };
    };
    ghcjs84 = callPackage ../development/haskell-modules rec {
      buildHaskellPackages = ghc.bootPkgs;
      ghc = bh.compiler.ghcjs84;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.4.x.nix { };
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghcjs.nix { };
    };

    # The integer-simple attribute set contains package sets for all the GHC compilers
    # using integer-simple instead of integer-gmp.
    integer-simple = let
      integerSimpleGhcNames = pkgs.lib.filter
        (name: ! builtins.elem name integerSimpleExcludes)
        (pkgs.lib.attrNames packages);
    in pkgs.lib.genAttrs integerSimpleGhcNames (name: packages."${name}".override {
      ghc = bh.compiler.integer-simple."${name}";
      buildHaskellPackages = bh.packages.integer-simple."${name}";
      overrides = _self : _super : {
        integer-simple = null;
        integer-gmp = null;
      };
    });

  };
}
