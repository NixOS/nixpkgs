{ buildPackages, pkgsBuildTarget, pkgs, newScope, stdenv }:

let
  # These are attributes in compiler and packages that don't support integer-simple.
  integerSimpleExcludes = [
    "ghc865Binary"
    "ghc8102Binary"
    "ghc8102BinaryMinimal"
    "ghc8107Binary"
    "ghc8107BinaryMinimal"
    "ghc922Binary"
    "ghc922BinaryMinimal"
    "ghcjs"
    "ghcjs810"
    "integer-simple"
    "native-bignum"
    "ghc902"
    "ghc924"
    "ghc941"
    "ghcHEAD"
  ];

  nativeBignumIncludes = [
    "ghc902"
    "ghc924"
    "ghc941"
    "ghcHEAD"
  ];

  haskellLibUncomposable = import ../development/haskell-modules/lib {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  callPackage = newScope {
    haskellLib = haskellLibUncomposable.compose;
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
  lib = haskellLibUncomposable;

  package-list = callPackage ../development/haskell-modules/package-list.nix {};

  compiler = {

    ghc865Binary = callPackage ../development/compilers/ghc/8.6.5-binary.nix {
      llvmPackages = pkgs.llvmPackages_6;
    };

    ghc8102Binary = callPackage ../development/compilers/ghc/8.10.2-binary.nix {
      llvmPackages = pkgs.llvmPackages_9;
    };

    ghc8102BinaryMinimal = callPackage ../development/compilers/ghc/8.10.2-binary.nix {
      llvmPackages = pkgs.llvmPackages_9;
      minimal = true;
    };

    ghc8107Binary = callPackage ../development/compilers/ghc/8.10.7-binary.nix {
      llvmPackages = pkgs.llvmPackages_12;
    };

    ghc8107BinaryMinimal = callPackage ../development/compilers/ghc/8.10.7-binary.nix {
      llvmPackages = pkgs.llvmPackages_12;
      minimal = true;
    };

    ghc922Binary = callPackage ../development/compilers/ghc/9.2.2-binary.nix {
      llvmPackages = pkgs.llvmPackages_12;
    };
    ghc922BinaryMinimal = callPackage ../development/compilers/ghc/9.2.2-binary.nix {
      llvmPackages = pkgs.llvmPackages_12;
      minimal = true;
    };

    ghc884 = callPackage ../development/compilers/ghc/8.8.4.nix {
      bootPkgs =
        # aarch64 ghc865Binary gets SEGVs due to haskell#15449 or similar
        # 8.10.2 is needed as using 8.10.7 is broken due to RTS-incompatibilities
        if stdenv.isAarch64 then
          packages.ghc8102BinaryMinimal
        # Musl bindists do not exist for ghc 8.6.5, so we use 8.10.* for them
        else if stdenv.hostPlatform.isMusl then
          packages.ghc8102Binary
        else
          packages.ghc865Binary;
      inherit (buildPackages.python3Packages) sphinx;
      buildTargetLlvmPackages = pkgsBuildTarget.llvmPackages_7;
      llvmPackages = pkgs.llvmPackages_7;
    };
    ghc8107 = callPackage ../development/compilers/ghc/8.10.7.nix {
      bootPkgs =
        # aarch64 ghc865Binary gets SEGVs due to haskell#15449 or similar
        # the oldest ghc with aarch64-darwin support is 8.10.5
        # Musl bindists do not exist for ghc 8.6.5, so we use 8.10.* for them
        if stdenv.hostPlatform.isAarch then
          packages.ghc8107BinaryMinimal
        else if stdenv.hostPlatform.isPower64 && stdenv.hostPlatform.isLittleEndian then
          # to my (@a-m-joseph) knowledge there are no newer official binaries for this platform
          packages.ghc865Binary
        else
          packages.ghc8107Binary;
      inherit (buildPackages.python3Packages) sphinx;
      # Need to use apple's patched xattr until
      # https://github.com/xattr/xattr/issues/44 and
      # https://github.com/xattr/xattr/issues/55 are solved.
      inherit (buildPackages.darwin) xattr autoSignDarwinBinariesHook;
      buildTargetLlvmPackages = pkgsBuildTarget.llvmPackages_12;
      llvmPackages = pkgs.llvmPackages_12;
    };
    ghc902 = callPackage ../development/compilers/ghc/9.0.2.nix {
      bootPkgs =
        # aarch64 ghc8107Binary exceeds max output size on hydra
        # the oldest ghc with aarch64-darwin support is 8.10.5
        if stdenv.hostPlatform.isAarch then
          packages.ghc8107BinaryMinimal
        else if stdenv.hostPlatform.isPower64 && stdenv.hostPlatform.isLittleEndian then
          packages.ghc8107
        else
          packages.ghc8107Binary;
      inherit (buildPackages.python3Packages) sphinx;
      inherit (buildPackages.darwin) autoSignDarwinBinariesHook xattr;
      buildTargetLlvmPackages = pkgsBuildTarget.llvmPackages_12;
      llvmPackages = pkgs.llvmPackages_12;
    };
    ghc924 = callPackage ../development/compilers/ghc/9.2.4.nix {
      bootPkgs =
        # aarch64 ghc8107Binary exceeds max output size on hydra
        if stdenv.hostPlatform.isAarch then
          packages.ghc8107BinaryMinimal
        else if stdenv.hostPlatform.isPower64 && stdenv.hostPlatform.isLittleEndian then
          packages.ghc8107
        else
          packages.ghc8107Binary;
      inherit (buildPackages.python3Packages) sphinx;
      # Need to use apple's patched xattr until
      # https://github.com/xattr/xattr/issues/44 and
      # https://github.com/xattr/xattr/issues/55 are solved.
      inherit (buildPackages.darwin) xattr autoSignDarwinBinariesHook;
      buildTargetLlvmPackages = pkgsBuildTarget.llvmPackages_12;
      llvmPackages = pkgs.llvmPackages_12;
    };
    ghc941 = callPackage ../development/compilers/ghc/9.4.1.nix {
      bootPkgs =
        # Building with 9.2 is broken due to
        # https://gitlab.haskell.org/ghc/ghc/-/issues/21914
        # Use 8.10 as a workaround where possible to keep bootstrap path short.

        # On ARM text won't build with GHC 8.10.*
        if stdenv.hostPlatform.isAarch then
          # TODO(@sternenseemann): package bindist
          packages.ghc902
        # No suitable bindists for powerpc64le
        else if stdenv.hostPlatform.isPower64 && stdenv.hostPlatform.isLittleEndian then
          packages.ghc902
        else
          packages.ghc8107Binary;
      inherit (buildPackages.python3Packages) sphinx;
      # Need to use apple's patched xattr until
      # https://github.com/xattr/xattr/issues/44 and
      # https://github.com/xattr/xattr/issues/55 are solved.
      inherit (buildPackages.darwin) xattr autoSignDarwinBinariesHook;
      # Support range >= 10 && < 14
      buildTargetLlvmPackages = pkgsBuildTarget.llvmPackages_12;
      llvmPackages = pkgs.llvmPackages_12;
    };
    ghcHEAD = callPackage ../development/compilers/ghc/head.nix {
      bootPkgs =
        if stdenv.hostPlatform.isPower64 && stdenv.hostPlatform.isLittleEndian then
          packages.ghc8107
        else
          packages.ghc8107Binary;
      inherit (buildPackages.python3Packages) sphinx;
      # Need to use apple's patched xattr until
      # https://github.com/xattr/xattr/issues/44 and
      # https://github.com/xattr/xattr/issues/55 are solved.
      inherit (buildPackages.darwin) xattr autoSignDarwinBinariesHook;
      buildTargetLlvmPackages = pkgsBuildTarget.llvmPackages_12;
      llvmPackages = pkgs.llvmPackages_12;
      libffi = pkgs.libffi;
    };

    ghcjs = compiler.ghcjs810;
    ghcjs810 = callPackage ../development/compilers/ghcjs/8.10 {
      bootPkgs = packages.ghc8107;
      ghcjsSrcJson = ../development/compilers/ghcjs/8.10/git.json;
      stage0 = ../development/compilers/ghcjs/8.10/stage0.nix;
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
    ghc8107Binary = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc8107Binary;
      ghc = bh.compiler.ghc8107Binary;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.10.x.nix { };
      packageSetConfig = bootstrapPackageSet;
    };
    ghc8107BinaryMinimal = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc8107BinaryMinimal;
      ghc = bh.compiler.ghc8107BinaryMinimal;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.10.x.nix { };
      packageSetConfig = bootstrapPackageSet;
    };
    ghc922Binary = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc922Binary;
      ghc = bh.compiler.ghc922Binary;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.2.x.nix { };
      packageSetConfig = bootstrapPackageSet;
    };
    ghc922BinaryMinimal = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc922BinaryMinimal;
      ghc = bh.compiler.ghc922BinaryMinimal;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.2.x.nix { };
      packageSetConfig = bootstrapPackageSet;
    };
    ghc884 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc884;
      ghc = bh.compiler.ghc884;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.8.x.nix { };
    };
    ghc8107 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc8107;
      ghc = bh.compiler.ghc8107;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.10.x.nix { };
    };
    ghc902 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc902;
      ghc = bh.compiler.ghc902;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.0.x.nix { };
    };
    ghc924 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc924;
      ghc = bh.compiler.ghc924;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.2.x.nix { };
    };
    ghc941 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc941;
      ghc = bh.compiler.ghc941;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.4.x.nix { };
    };
    ghcHEAD = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghcHEAD;
      ghc = bh.compiler.ghcHEAD;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-head.nix { };
    };

    ghcjs = packages.ghcjs810;
    ghcjs810 = callPackage ../development/haskell-modules rec {
      buildHaskellPackages = ghc.bootPkgs;
      ghc = bh.compiler.ghcjs810;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.10.x.nix { };
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghcjs.nix { };
    };

    # The integer-simple attribute set contains package sets for all the GHC compilers
    # using integer-simple instead of integer-gmp.
    integer-simple =
      let
        integerSimpleGhcNames = pkgs.lib.filter
          (name: ! builtins.elem name integerSimpleExcludes)
          (pkgs.lib.attrNames packages);
      in
      pkgs.lib.genAttrs integerSimpleGhcNames
        (name:
          packages.${name}.override (oldAttrs: {
            ghc = bh.compiler.integer-simple.${name};
            buildHaskellPackages = bh.packages.integer-simple.${name};
            overrides =
              pkgs.lib.composeExtensions
                (oldAttrs.overrides or (_: _: {}))
                (_: _: { integer-simple = null; });
          })
        );

    native-bignum =
      let
        nativeBignumGhcNames = pkgs.lib.filter
          (name: builtins.elem name nativeBignumIncludes)
          (pkgs.lib.attrNames compiler);
      in
      pkgs.lib.genAttrs nativeBignumGhcNames
        (name:
          packages.${name}.override {
            ghc = bh.compiler.native-bignum.${name};
            buildHaskellPackages = bh.packages.native-bignum.${name};
          }
        );
  };
}
