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

  # Use this rather than `rec { ... }` below for sake of overlays.
  inherit (pkgs.haskell) compiler packages;

  # make sure we build cross compiler as technically stage3 compiler. That is
  # we build them with the same version they are instead of the bootstrap compiler.
  # For regular builds we'll use the bootstrap version.
  mkBootPkgs = ver: boot: if pkgs.stdenv.hostPlatform != pkgs.stdenv.targetPlatform then buildPackages.haskell.packages.${ver} else packages.${boot};

in {
  lib = haskellLib;

  compiler = {

    ghc7103Binary = callPackage ../development/compilers/ghc/7.10.3-binary.nix { };
    ghc821Binary = callPackage ../development/compilers/ghc/8.2.1-binary.nix { };

    ghc7103 = callPackage ../development/compilers/ghc/7.10.3.nix {
      bootPkgs = packages.ghc7103Binary;
      buildLlvmPackages = buildPackages.llvmPackages_35;
      llvmPackages = pkgs.llvmPackages_35;
    };
    ghc802 = callPackage ../development/compilers/ghc/8.0.2.nix {
      bootPkgs = mkBootPkgs "ghc802" "ghc7103Binary";
      inherit (buildPackages.python27Packages) sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_37;
      llvmPackages = pkgs.llvmPackages_37;
    };
    ghc822 = callPackage ../development/compilers/ghc/8.2.2.nix {
      bootPkgs = mkBootPkgs "ghc822" "ghc821Binary";
      inherit (buildPackages.python3Packages) sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_39;
      llvmPackages = pkgs.llvmPackages_39;
    };
    ghc843 = callPackage ../development/compilers/ghc/8.4.3.nix {
      bootPkgs = mkBootPkgs "ghc843" "ghc821Binary";
      buildLlvmPackages = buildPackages.llvmPackages_5;
      llvmPackages = pkgs.llvmPackages_5;
    };
    ghc844 = callPackage ../development/compilers/ghc/8.4.4.nix {
      bootPkgs = mkBootPkgs "ghc844" "ghc821Binary";
      buildLlvmPackages = buildPackages.llvmPackages_5;
      llvmPackages = pkgs.llvmPackages_5;
    };
    ghc861 = callPackage ../development/compilers/ghc/8.6.1.nix {
      bootPkgs = mkBootPkgs "ghc861" "ghc822";
      inherit (buildPackages.python3Packages) sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_6;
      llvmPackages = pkgs.llvmPackages_6;
    };
    ghc862 = callPackage ../development/compilers/ghc/8.6.2.nix {
      bootPkgs = mkBootPkgs "ghc862" "ghc822";
      inherit (buildPackages.python3Packages) sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_6;
      llvmPackages = pkgs.llvmPackages_6;
    };
    ghc863 = callPackage ../development/compilers/ghc/8.6.3.nix {
      bootPkgs = mkBootPkgs "ghc863" "ghc822";
      inherit (buildPackages.python3Packages) sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_6;
      llvmPackages = pkgs.llvmPackages_6;
    };
    ghc864 = callPackage ../development/compilers/ghc/8.6.4.nix {
      bootPkgs = mkBootPkgs "ghc864" "ghc822";
      inherit (buildPackages.python3Packages) sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_6;
      llvmPackages = pkgs.llvmPackages_6;
    };
    ghc865 = callPackage ../development/compilers/ghc/8.6.5.nix {
      bootPkgs = mkBootPkgs "ghc864" "ghc822";
      inherit (buildPackages.python3Packages) sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_6;
      llvmPackages = pkgs.llvmPackages_6;
    };
    ghcHEAD = callPackage ../development/compilers/ghc/head.nix {
      bootPkgs = mkBootPkgs "ghcHEAD" "ghc863";
      inherit (buildPackages.python3Packages) sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_5;
      llvmPackages = pkgs.llvmPackages_5;
    };
    ghcjs = compiler.ghcjs84;
    # Use `import` because `callPackage inside`.
    ghcjs710 = import ../development/compilers/ghcjs/7.10 {
      bootPkgs = buildPackages.ghc7103;
      inherit (pkgs) cabal-install;
      inherit (buildPackages) fetchgit fetchFromGitHub;
    };
    # `import` on purpose; see above.
    ghcjs80 = import ../development/compilers/ghcjs/8.0 {
      bootPkgs = buildPackages.ghc802;
      inherit (pkgs) cabal-install;
      inherit (buildPackages) fetchgit fetchFromGitHub;
    };
    ghcjs82 = callPackage ../development/compilers/ghcjs-ng {
      bootPkgs = buildPackages.ghc822;
      ghcjsSrcJson = ../development/compilers/ghcjs-ng/8.2/git.json;
      stage0 = ../development/compilers/ghcjs-ng/8.2/stage0.nix;
    };
    ghcjs84 = callPackage ../development/compilers/ghcjs-ng {
      bootPkgs = buildPackages.ghc843;
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
  } //
  ( if pkgs.stdenv.hostPlatform.isGhcjs
    then {
      ghc802 = compiler.ghcjs80;
      ghc822 = compiler.ghcjs82;
      ghc843 = compiler.ghcjs84;
      ghc844 = compiler.ghcjs84;
      ghc861 = compiler.ghcjs86;
      ghc862 = compiler.ghcjs86;
      ghc863 = compiler.ghcjs86;
      ghc864 = compiler.ghcjs86;
    }
    else {}
  ) //
  ( if pkgs.stdenv.hostPlatform.isAsterius
    then {
      ghc802 = compiler.asterius;
      ghc822 = compiler.asterius;
      ghc843 = compiler.asterius;
      ghc844 = compiler.asterius;
      ghc861 = compiler.asterius;
      ghc862 = compiler.asterius;
      ghc863 = compiler.asterius;
      ghc864 = compiler.asterius;
    }
    else {}
  );

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
    ghc844 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc844;
      ghc = bh.compiler.ghc844;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.4.x.nix { };
    };
    ghc861 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc861;
      ghc = bh.compiler.ghc861;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.6.x.nix { };
    };
    ghc862 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc862;
      ghc = bh.compiler.ghc862;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.6.x.nix { };
    };
    ghc863 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc863;
      ghc = bh.compiler.ghc863;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.6.x.nix { };
    };
    ghc864 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc864;
      ghc = bh.compiler.ghc864;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.6.x.nix { };
    };
    ghc865 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc865;
      ghc = bh.compiler.ghc865;
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
