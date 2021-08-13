{ buildPackages, pkgs, newScope, stdenv }:

let
  # These are attributes in compiler and packages that don't support integer-simple.
  integerSimpleExcludes = [
    "ghc865Binary"
    "ghc8102Binary"
    "ghc8102BinaryMinimal"
    "integer-simple"
    "native-bignum"
    "ghcHEAD"
  ];

  nativeBignumIncludes = [
    "ghcHEAD"
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

  package-list = callPackage ../development/haskell-modules/package-list.nix {};

  compiler = {

    ghc865Binary = callPackage ../development/compilers/ghc/8.6.5-binary.nix { };

    ghc8102Binary = callPackage ../development/compilers/ghc/8.10.2-binary.nix {
      llvmPackages = pkgs.llvmPackages_9;
    };

    ghc8102BinaryMinimal = callPackage ../development/compilers/ghc/8.10.2-binary.nix {
      llvmPackages = pkgs.llvmPackages_9;
      minimal = true;
    };

    ghc884 = callPackage ../development/compilers/ghc/8.8.4.nix {
      # aarch64 ghc865Binary gets SEGVs due to haskell#15449 or similar
      # Musl bindists do not exist for ghc 8.6.5, so we use 8.10.* for them
      bootPkgs = if stdenv.isAarch64 || stdenv.targetPlatform.isMusl then
          packages.ghc8102BinaryMinimal
        else
          packages.ghc865Binary;
      inherit (buildPackages.python3Packages) sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_7;
      llvmPackages = pkgs.llvmPackages_7;
    };
    ghc8104 = callPackage ../development/compilers/ghc/8.10.4.nix {
      # aarch64 ghc865Binary gets SEGVs due to haskell#15449 or similar
      # Musl bindists do not exist for ghc 8.6.5, so we use 8.10.* for them
      bootPkgs = if stdenv.isAarch64 || stdenv.isAarch32 || stdenv.targetPlatform.isMusl then
          packages.ghc8102BinaryMinimal
        else
          packages.ghc865Binary;
      inherit (buildPackages.python3Packages) sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_9;
      llvmPackages = pkgs.llvmPackages_9;
    };
    ghc901 = callPackage ../development/compilers/ghc/9.0.1.nix {
      # aarch64 ghc8102Binary exceeds max output size on hydra
      bootPkgs = if stdenv.isAarch64 || stdenv.isAarch32 then
          packages.ghc8102BinaryMinimal
        else
          packages.ghc8102Binary;
      inherit (buildPackages.python3Packages) sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_10;
      llvmPackages = pkgs.llvmPackages_10;
    };
    ghcHEAD = callPackage ../development/compilers/ghc/head.nix {
      bootPkgs = packages.ghc901; # no binary yet
      inherit (buildPackages.python3Packages) sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_10;
      llvmPackages = pkgs.llvmPackages_10;
      libffi = pkgs.libffi;
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

    # Starting from GHC 9, integer-{simple,gmp} is replaced by ghc-bignum
    # with "native" and "gmp" backends.
    native-bignum = let
      nativeBignumGhcNames = pkgs.lib.filter
        (name: builtins.elem name nativeBignumIncludes)
        (pkgs.lib.attrNames compiler);
    in pkgs.recurseIntoAttrs (pkgs.lib.genAttrs
      nativeBignumGhcNames
      (name: compiler.${name}.override { enableNativeBignum = true; }));
  };

  # Default overrides that are applied to all package sets.
  packageOverrides = self : super : {};

  # Always get compilers from `buildPackages`
  packages = let bh = buildPackages.haskell; in {

    ghc865Binary = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc865Binary;
      ghc = bh.compiler.ghc865Binary;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.6.x.nix { };
      packageSetConfig = bootstrapPackageSet;
    };
    ghc8102Binary = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc8102Binary;
      ghc = bh.compiler.ghc8102Binary;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.10.x.nix { };
      packageSetConfig = bootstrapPackageSet;
    };
    ghc8102BinaryMinimal = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc8102BinaryMinimal;
      ghc = bh.compiler.ghc8102BinaryMinimal;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.10.x.nix { };
      packageSetConfig = bootstrapPackageSet;
    };
    ghc884 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc884;
      ghc = bh.compiler.ghc884;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.8.x.nix { };
    };
    ghc8104 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc8104;
      ghc = bh.compiler.ghc8104;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.10.x.nix { };
    };
    ghc901 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc901;
      ghc = bh.compiler.ghc901;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.0.x.nix { };
    };
    ghcHEAD = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghcHEAD;
      ghc = bh.compiler.ghcHEAD;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-head.nix { };
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

    native-bignum = let
      nativeBignumGhcNames = pkgs.lib.filter
        (name: builtins.elem name nativeBignumIncludes)
        (pkgs.lib.attrNames compiler);
    in pkgs.lib.genAttrs nativeBignumGhcNames (name: packages.${name}.override {
      ghc = bh.compiler.native-bignum.${name};
      buildHaskellPackages = bh.packages.native-bignum.${name};
      overrides = _self : _super : {
        integer-gmp = null;
      };
    });
  };
}
