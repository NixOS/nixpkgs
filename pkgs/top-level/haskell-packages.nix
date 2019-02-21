{ buildPackages, pkgs
, newScope
}:

let
  # These are attributes in compiler and packages that don't support integer-simple.
  integerSimpleExcludes = [
    "ghc822Binary"
    "ghc863Binary"
    "ghc844"
    "ghcjs"
    "ghcjs84"
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

    ghc863Binary = callPackage ../development/compilers/ghc/8.6.3-binary.nix { };

    ghc822 = callPackage ../development/compilers/ghc/8.2.2.nix {
      bootPkgs = packages.ghc822Binary;
      inherit (buildPackages.python3Packages) sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_39;
      llvmPackages = pkgs.llvmPackages_39;
    };
    ghc844 = callPackage ../development/compilers/ghc/8.4.4.nix {
      bootPkgs = packages.ghc822Binary;
      inherit (buildPackages.python3Packages) sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_5;
      llvmPackages = pkgs.llvmPackages_5;
    };
    ghc861 = callPackage ../development/compilers/ghc/8.6.1.nix {
      bootPkgs = packages.ghc822Binary;
      inherit (buildPackages.python3Packages) sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_6;
      llvmPackages = pkgs.llvmPackages_6;
    };
    ghc862 = callPackage ../development/compilers/ghc/8.6.2.nix {
      bootPkgs = packages.ghc822Binary;
      inherit (buildPackages.python3Packages) sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_6;
      llvmPackages = pkgs.llvmPackages_6;
    };
    ghc863 = callPackage ../development/compilers/ghc/8.6.3.nix {
      bootPkgs = packages.ghc822Binary;
      inherit (buildPackages.python3Packages) sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_6;
      llvmPackages = pkgs.llvmPackages_6;
    };
    ghcHEAD = callPackage ../development/compilers/ghc/head.nix {
      bootPkgs = packages.ghc863Binary;
      inherit (buildPackages.python3Packages) sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_6;
      llvmPackages = pkgs.llvmPackages_6;
    };
    ghcjs = compiler.ghcjs86;
    ghcjs84 = callPackage ../development/compilers/ghcjs-ng {
      bootPkgs = packages.ghc844;
      ghcjsSrcJson = ../development/compilers/ghcjs-ng/8.4/git.json;
      stage0 = ../development/compilers/ghcjs-ng/8.4/stage0.nix;
      ghcjsDepOverrides = import ../development/compilers/ghcjs-ng/8.4/dep-overrides.nix { inherit haskellLib; };
    };
    ghcjs86 = callPackage ../development/compilers/ghcjs-ng {
      bootPkgs = packages.ghc863;
      ghcjsSrcJson = ../development/compilers/ghcjs-ng/8.6/git.json;
      stage0 = ../development/compilers/ghcjs-ng/8.6/stage0.nix;
      ghcjsDepOverrides = import ../development/compilers/ghcjs-ng/8.6/dep-overrides.nix { inherit haskellLib; };
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

    ghc822Binary = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc822Binary;
      ghc = bh.compiler.ghc822Binary;
      compilerConfig = import ../development/haskell-modules/configuration-ghc-8.2.x.nix { inherit pkgs haskellLib; };
      packageSetConfig = bootstrapPackageSet;
    };
    ghc863Binary = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc863Binary;
      ghc = bh.compiler.ghc863Binary;
      compilerConfig = import ../development/haskell-modules/configuration-ghc-8.6.x.nix { inherit pkgs haskellLib; };
      packageSetConfig = bootstrapPackageSet;
    };
    ghc822 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc822;
      ghc = bh.compiler.ghc822;
      compilerConfig = import ../development/haskell-modules/configuration-ghc-8.2.x.nix { inherit pkgs haskellLib; };
    };
    ghc844 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc844;
      ghc = bh.compiler.ghc844;
      compilerConfig = import ../development/haskell-modules/configuration-ghc-8.4.x.nix { inherit pkgs haskellLib; };
    };
    ghc861 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc861;
      ghc = bh.compiler.ghc861;
      compilerConfig = import ../development/haskell-modules/configuration-ghc-8.6.x.nix { inherit pkgs haskellLib; };
    };
    ghc862 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc862;
      ghc = bh.compiler.ghc862;
      compilerConfig = import ../development/haskell-modules/configuration-ghc-8.6.x.nix { inherit pkgs haskellLib; };
    };
    ghc863 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc863;
      ghc = bh.compiler.ghc863;
      compilerConfig = import ../development/haskell-modules/configuration-ghc-8.6.x.nix { inherit pkgs haskellLib; };
    };
    ghcHEAD = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghcHEAD;
      ghc = bh.compiler.ghcHEAD;
      compilerConfig = import ../development/haskell-modules/configuration-ghc-head.nix { inherit pkgs haskellLib; };
    };
    ghcjs = packages.ghcjs86;
    ghcjs84 = callPackage ../development/haskell-modules rec {
      buildHaskellPackages = ghc.bootPkgs;
      ghc = bh.compiler.ghcjs84;
      compilerConfig = import ../development/haskell-modules/configuration-ghc-8.4.x.nix { inherit pkgs haskellLib; };
      packageSetConfig = import ../development/haskell-modules/configuration-ghcjs.nix { inherit pkgs haskellLib; };
    };
    ghcjs86 = callPackage ../development/haskell-modules rec {
      buildHaskellPackages = ghc.bootPkgs;
      ghc = bh.compiler.ghcjs86;
      compilerConfig = import ../development/haskell-modules/configuration-ghc-8.6.x.nix { inherit pkgs haskellLib; };
      packageSetConfig = import ../development/haskell-modules/configuration-ghcjs.nix { inherit pkgs haskellLib; };
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
