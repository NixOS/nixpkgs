{ buildPackages, pkgsBuildTarget, pkgs, newScope, stdenv }:

let
  # These are attributes in compiler that support integer-simple.
  integerSimpleIncludes = [
    "ghc88"
    "ghc884"
    "ghc810"
    "ghc8107"
  ];

  nativeBignumIncludes = [
    "ghc90"
    "ghc902"
    "ghc92"
    "ghc925"
    "ghc926"
    "ghc927"
    "ghc928"
    "ghc94"
    "ghc945"
    "ghc946"
    "ghc947"
    "ghc948"
    "ghc96"
    "ghc963"
    "ghc98"
    "ghc981"
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
      # Should be llvmPackages_6 which has been removed from nixpkgs
      llvmPackages = null;
    };

    ghc8102Binary = callPackage ../development/compilers/ghc/8.10.2-binary.nix {
      llvmPackages = pkgs.llvmPackages_9;
    };

    ghc8107Binary = callPackage ../development/compilers/ghc/8.10.7-binary.nix {
      llvmPackages = pkgs.llvmPackages_12;
    };

    ghc924Binary = callPackage ../development/compilers/ghc/9.2.4-binary.nix {
      llvmPackages = pkgs.llvmPackages_12;
    };

    ghc8107 = callPackage ../development/compilers/ghc/8.10.7.nix {
      bootPkgs =
        # the oldest ghc with aarch64-darwin support is 8.10.5
        if stdenv.hostPlatform.isPower64 && stdenv.hostPlatform.isLittleEndian then
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
    ghc810 = compiler.ghc8107;
    ghc902 = callPackage ../development/compilers/ghc/9.0.2.nix {
      bootPkgs =
        # the oldest ghc with aarch64-darwin support is 8.10.5
        if stdenv.hostPlatform.isPower64 && stdenv.hostPlatform.isLittleEndian then
          packages.ghc810
        else
          packages.ghc8107Binary;
      inherit (buildPackages.python3Packages) sphinx;
      inherit (buildPackages.darwin) autoSignDarwinBinariesHook xattr;
      buildTargetLlvmPackages = pkgsBuildTarget.llvmPackages_12;
      llvmPackages = pkgs.llvmPackages_12;
    };
    ghc90 = compiler.ghc902;
    ghc925 = callPackage ../development/compilers/ghc/9.2.5.nix {
      bootPkgs =
        if stdenv.hostPlatform.isPower64 && stdenv.hostPlatform.isLittleEndian then
          packages.ghc810
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
    ghc926 = callPackage ../development/compilers/ghc/9.2.6.nix {
      bootPkgs =
        if stdenv.hostPlatform.isPower64 && stdenv.hostPlatform.isLittleEndian then
          packages.ghc810
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
    ghc927 = callPackage ../development/compilers/ghc/9.2.7.nix {
      bootPkgs =
        if stdenv.hostPlatform.isPower64 && stdenv.hostPlatform.isLittleEndian then
          packages.ghc810
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
    ghc928 = callPackage ../development/compilers/ghc/9.2.8.nix {
      bootPkgs =
        if stdenv.hostPlatform.isPower64 && stdenv.hostPlatform.isLittleEndian then
          packages.ghc810
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
    ghc92 = compiler.ghc928;
    ghc945 = callPackage ../development/compilers/ghc/9.4.5.nix {
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
    ghc946 = callPackage ../development/compilers/ghc/9.4.6.nix {
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
    ghc947 = callPackage ../development/compilers/ghc/9.4.7.nix {
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
    ghc948 = callPackage ../development/compilers/ghc/9.4.8.nix {
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
    ghc94 = compiler.ghc948;
    ghc963 = callPackage ../development/compilers/ghc/9.6.3.nix {
      bootPkgs =
        # For GHC 9.2 no armv7l bindists are available.
        if stdenv.hostPlatform.isAarch32 then
          packages.ghc928
        else if stdenv.hostPlatform.isPower64 && stdenv.hostPlatform.isLittleEndian then
          packages.ghc928
        else
          packages.ghc924Binary;
      inherit (buildPackages.python3Packages) sphinx;
      # Need to use apple's patched xattr until
      # https://github.com/xattr/xattr/issues/44 and
      # https://github.com/xattr/xattr/issues/55 are solved.
      inherit (buildPackages.darwin) xattr autoSignDarwinBinariesHook;
      # Support range >= 11 && < 16
      buildTargetLlvmPackages = pkgsBuildTarget.llvmPackages_15;
      llvmPackages = pkgs.llvmPackages_15;
    };
    ghc96 = compiler.ghc963;
    ghc981 = callPackage ../development/compilers/ghc/9.8.1.nix {
      # No bindist packaged for 9.4.* yet
      bootPkgs = packages.ghc947;
      inherit (buildPackages.python3Packages) sphinx;
      # Need to use apple's patched xattr until
      # https://github.com/xattr/xattr/issues/44 and
      # https://github.com/xattr/xattr/issues/55 are solved.
      inherit (buildPackages.darwin) xattr autoSignDarwinBinariesHook;
      # Support range >= 11 && < 16
      buildTargetLlvmPackages = pkgsBuildTarget.llvmPackages_15;
      llvmPackages = pkgs.llvmPackages_15;
    };
    ghc98 = compiler.ghc981;
    ghcHEAD = callPackage ../development/compilers/ghc/head.nix {
      bootPkgs = packages.ghc963;
      inherit (buildPackages.python3Packages) sphinx;
      # Need to use apple's patched xattr until
      # https://github.com/xattr/xattr/issues/44 and
      # https://github.com/xattr/xattr/issues/55 are solved.
      inherit (buildPackages.darwin) xattr autoSignDarwinBinariesHook;
      # 2023-01-15: Support range >= 11 && < 16
      buildTargetLlvmPackages = pkgsBuildTarget.llvmPackages_15;
      llvmPackages = pkgs.llvmPackages_15;
    };

    ghcjs = compiler.ghcjs810;
    ghcjs810 = callPackage ../development/compilers/ghcjs/8.10 {
      bootPkgs = packages.ghc810;
      ghcjsSrcJson = ../development/compilers/ghcjs/8.10/git.json;
      stage0 = ../development/compilers/ghcjs/8.10/stage0.nix;
    };

    # The integer-simple attribute set contains all the GHC compilers
    # build with integer-simple instead of integer-gmp.
    integer-simple = let
      integerSimpleGhcNames = pkgs.lib.filter
        (name: builtins.elem name integerSimpleIncludes)
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
    ghc8107Binary = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc8107Binary;
      ghc = bh.compiler.ghc8107Binary;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.10.x.nix { };
      packageSetConfig = bootstrapPackageSet;
    };
    ghc924Binary = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc924Binary;
      ghc = bh.compiler.ghc924Binary;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.2.x.nix { };
      packageSetConfig = bootstrapPackageSet;
    };
    ghc8107 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc8107;
      ghc = bh.compiler.ghc8107;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.10.x.nix { };
    };
    ghc810 = packages.ghc8107;
    ghc902 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc902;
      ghc = bh.compiler.ghc902;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.0.x.nix { };
    };
    ghc90 = packages.ghc902;
    ghc925 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc925;
      ghc = bh.compiler.ghc925;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.2.x.nix { };
    };
    ghc926 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc926;
      ghc = bh.compiler.ghc926;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.2.x.nix { };
    };
    ghc927 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc927;
      ghc = bh.compiler.ghc927;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.2.x.nix { };
    };
    ghc928 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc928;
      ghc = bh.compiler.ghc928;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.2.x.nix { };
    };
    ghc92 = packages.ghc928;
    ghc945 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc945;
      ghc = bh.compiler.ghc945;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.4.x.nix { };
    };
    ghc946 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc946;
      ghc = bh.compiler.ghc946;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.4.x.nix { };
    };
    ghc947 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc947;
      ghc = bh.compiler.ghc947;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.4.x.nix { };
    };
    ghc948 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc948;
      ghc = bh.compiler.ghc948;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.4.x.nix { };
    };
    ghc94 = packages.ghc948;
    ghc963 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc963;
      ghc = bh.compiler.ghc963;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.6.x.nix { };
    };
    ghc96 = packages.ghc963;
    ghc981 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc981;
      ghc = bh.compiler.ghc981;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.8.x.nix { };
    };
    ghc98 = packages.ghc981;
    ghcHEAD = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghcHEAD;
      ghc = bh.compiler.ghcHEAD;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.10.x.nix { };
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
          (name: builtins.elem name integerSimpleIncludes)
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
