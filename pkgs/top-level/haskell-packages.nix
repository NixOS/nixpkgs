{ buildPackages, pkgs, newScope }:

let
  # These are attributes in compiler and packages that don't support integer-simple.
  integerSimpleExcludes = [
    "ghc822Binary"
    "ghc865Binary"
    "ghcjs"
    "ghcjs86"
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

  # Use this rather than `rec { ... }` below for sake of overlays.
  inherit (pkgs.haskell) compiler packages;

in {
  lib = haskellLib;

  compiler = {

    ghc822Binary = callPackage ../development/compilers/ghc/8.2.2-binary.nix { };

    ghc865Binary = callPackage ../development/compilers/ghc/8.6.5-binary.nix { };

    ghc865 = callPackage ../development/compilers/ghc/8.6.5.nix {
      bootPkgs = packages.ghc822Binary;
      inherit (buildPackages.python3Packages) sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_6;
      llvmPackages = pkgs.llvmPackages_6;
    };
    ghc882 = callPackage ../development/compilers/ghc/8.8.2.nix {
      bootPkgs = packages.ghc865Binary;
      inherit (buildPackages.python3Packages) sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_7;
      llvmPackages = pkgs.llvmPackages_7;
    };
    ghc883 = callPackage ../development/compilers/ghc/8.8.3.nix {
      bootPkgs = packages.ghc865Binary;
      inherit (buildPackages.python3Packages) sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_7;
      llvmPackages = pkgs.llvmPackages_7;
    };
    ghc884 = callPackage ../development/compilers/ghc/8.8.4.nix {
      bootPkgs = packages.ghc865Binary;
      inherit (buildPackages.python3Packages) sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_7;
      llvmPackages = pkgs.llvmPackages_7;
    };
    ghc8101 = callPackage ../development/compilers/ghc/8.10.1.nix {
      bootPkgs = packages.ghc865Binary;
      inherit (buildPackages.python3Packages) sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_9;
      llvmPackages = pkgs.llvmPackages_9;
    };
    ghcHEAD = callPackage ../development/compilers/ghc/head.nix {
      bootPkgs = packages.ghc883; # no binary yet
      inherit (buildPackages.python3Packages) sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_10;
      llvmPackages = pkgs.llvmPackages_10;
      libffi = pkgs.libffi;
    };
    ghcjs = compiler.ghcjs86;
    ghcjs86 = callPackage ../development/compilers/ghcjs-ng {
      bootPkgs = packages.ghc865;
      ghcjsSrcJson = ../development/compilers/ghcjs-ng/8.6/git.json;
      stage0 = ../development/compilers/ghcjs-ng/8.6/stage0.nix;
      ghcjsDepOverrides = callPackage ../development/compilers/ghcjs-ng/8.6/dep-overrides.nix {};
    };

    # The integer-simple attribute set contains all the GHC compilers
    # build with integer-simple instead of integer-gmp.
    integer-simple = let
      integerSimpleGhcNames = pkgs.lib.filter
        (name: ! builtins.elem name integerSimpleExcludes)
        (pkgs.lib.attrNames compiler);
    in pkgs.recurseIntoAttrs (pkgs.lib.genAttrs
      integerSimpleGhcNames
      (name: compiler.${name}.override { enableIntegerSimple = true; }));
  };

  # Default overrides that are applied to all package sets.
  packageOverrides = self : super : {};

  # Always get compilers from `buildPackages`
  packages = let bh = buildPackages.haskell; in {

    ghc822Binary = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc822Binary;
      ghc = bh.compiler.ghc822Binary;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.2.x.nix { };
      packageSetConfig = bootstrapPackageSet;
    };
    ghc865Binary = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc865Binary;
      ghc = bh.compiler.ghc865Binary;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.6.x.nix { };
      packageSetConfig = bootstrapPackageSet;
    };
    ghc865 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc865;
      ghc = bh.compiler.ghc865;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.6.x.nix { };
    };
    ghc882 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc882;
      ghc = bh.compiler.ghc882;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.8.x.nix { };
    };
    ghc883 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc883;
      ghc = bh.compiler.ghc883;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.8.x.nix { };
    };
    ghc884 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc884;
      ghc = bh.compiler.ghc884;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.8.x.nix { };
    };
    ghc8101 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc8101;
      ghc = bh.compiler.ghc8101;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.10.x.nix { };
    };
    ghcHEAD = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghcHEAD;
      ghc = bh.compiler.ghcHEAD;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-head.nix { };
    };
    ghcjs = packages.ghcjs86;
    ghcjs86 = callPackage ../development/haskell-modules rec {
      buildHaskellPackages = ghc.bootPkgs;
      ghc = bh.compiler.ghcjs86;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.6.x.nix { };
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghcjs.nix { };
    };

    # The integer-simple attribute set contains package sets for all the GHC compilers
    # using integer-simple instead of integer-gmp.
    integer-simple = let
      integerSimpleGhcNames = pkgs.lib.filter
        (name: ! builtins.elem name integerSimpleExcludes)
        (pkgs.lib.attrNames packages);
    in pkgs.lib.genAttrs integerSimpleGhcNames (name: packages.${name}.override {
      ghc = bh.compiler.integer-simple.${name};
      buildHaskellPackages = bh.packages.integer-simple.${name};
      overrides = _self : _super : {
        integer-simple = null;
        integer-gmp = null;
      };
    });

  };
}
