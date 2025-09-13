{
  buildPackages,
  pkgsBuildBuild,
  pkgsBuildTarget,
  pkgs,
  newScope,
  stdenv,
  config,
}:

let
  nativeBignumExcludes = [
    # haskell.compiler sub groups
    "native-bignum"
    # Binary GHCs
    "ghc902Binary"
    "ghc924Binary"
    "ghc963Binary"
    "ghc984Binary"
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
    mkDerivation =
      drv:
      super.mkDerivation (
        drv
        // {
          doCheck = false;
          doHaddock = false;
          enableExecutableProfiling = false;
          enableLibraryProfiling = false;
          enableSharedExecutables = false;
          enableSharedLibraries = false;
        }
      );
  };

  # Use this rather than `rec { ... }` below for sake of overlays.
  inherit (pkgs.haskell) compiler packages;

in
{
  lib = haskellLibUncomposable;

  package-list = callPackage ../development/haskell-modules/package-list.nix { };

  # Always get boot compilers from `pkgsBuildBuild`. The boot (stage0) compiler
  # is used to build another compiler (stage1) that'll be used to build the
  # final compiler (stage2) (except when building a cross-compiler). This means
  # that stage1's host platform is the same as stage0: build. Consequently,
  # stage0 needs to be build->build.
  #
  # Note that we use bb.haskell.packages.*. haskell.packages.*.ghc is similar to
  # stdenv: The ghc comes from the previous package set, i.e. this predicate holds:
  # `name: pkgs: pkgs.haskell.packages.${name}.ghc == pkgs.buildPackages.haskell.compiler.${name}.ghc`.
  # This isn't problematic since pkgsBuildBuild.buildPackages is also build->build,
  # just something to keep in mind.
  compiler = pkgs.lib.recurseIntoAttrs (
    let
      bb = pkgsBuildBuild.haskell;
    in
    {
      # Required to bootstrap 9.4.8.
      ghc902Binary = callPackage ../development/compilers/ghc/9.0.2-binary.nix {
        llvmPackages = pkgs.llvmPackages_20;
      };

      ghc924Binary = callPackage ../development/compilers/ghc/9.2.4-binary.nix { };

      ghc963Binary = callPackage ../development/compilers/ghc/9.6.3-binary.nix { };

      ghc984Binary = callPackage ../development/compilers/ghc/9.8.4-binary.nix { };

      ghc948 = callPackage ../development/compilers/ghc/9.4.8.nix {
        bootPkgs =
          # Building with 9.2 is broken due to
          # https://gitlab.haskell.org/ghc/ghc/-/issues/21914
          bb.packages.ghc902Binary;
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
        bootPkgs = bb.packages.ghc924Binary;
        inherit (buildPackages.python3Packages) sphinx;
        # Need to use apple's patched xattr until
        # https://github.com/xattr/xattr/issues/44 and
        # https://github.com/xattr/xattr/issues/55 are solved.
        inherit (buildPackages.darwin) xattr autoSignDarwinBinariesHook;
        # Support range >= 11 && < 16
        buildTargetLlvmPackages = pkgsBuildTarget.llvmPackages_15;
        llvmPackages = pkgs.llvmPackages_15;
      };
      ghc967 = callPackage ../development/compilers/ghc/9.6.7.nix {
        bootPkgs = bb.packages.ghc924Binary;
        inherit (buildPackages.python3Packages) sphinx;
        # Need to use apple's patched xattr until
        # https://github.com/xattr/xattr/issues/44 and
        # https://github.com/xattr/xattr/issues/55 are solved.
        inherit (buildPackages.darwin) xattr autoSignDarwinBinariesHook;
        # Support range >= 11 && < 16
        buildTargetLlvmPackages = pkgsBuildTarget.llvmPackages_15;
        llvmPackages = pkgs.llvmPackages_15;
      };
      ghc96 = compiler.ghc967;
      ghc984 = callPackage ../development/compilers/ghc/9.8.4.nix {
        bootPkgs =
          if stdenv.buildPlatform.isAarch64 && stdenv.buildPlatform.isMusl then
            bb.packages.ghc984Binary
          else
            bb.packages.ghc963Binary;
        inherit (buildPackages.python3Packages) sphinx;
        # Need to use apple's patched xattr until
        # https://github.com/xattr/xattr/issues/44 and
        # https://github.com/xattr/xattr/issues/55 are solved.
        inherit (buildPackages.darwin) xattr autoSignDarwinBinariesHook;
        # Support range >= 11 && < 16
        buildTargetLlvmPackages = pkgsBuildTarget.llvmPackages_15;
        llvmPackages = pkgs.llvmPackages_15;
      };
      ghc98 = compiler.ghc984;
      ghc9101 = callPackage ../development/compilers/ghc/9.10.1.nix {
        bootPkgs =
          if stdenv.buildPlatform.isDarwin then
            # it seems like the GHC 9.6.* bindists are built with a different
            # toolchain than we are using (which I'm guessing from the fact
            # that 9.6.4 bindists pass linker flags our ld doesn't support).
            # With both 9.6.3 and 9.6.4 binary it is impossible to link against
            # the clock package (probably a hsc2hs problem).
            bb.packages.ghc963
          else
            bb.packages.ghc963Binary;
        inherit (buildPackages.python3Packages) sphinx;
        # Need to use apple's patched xattr until
        # https://github.com/xattr/xattr/issues/44 and
        # https://github.com/xattr/xattr/issues/55 are solved.
        inherit (buildPackages.darwin) xattr autoSignDarwinBinariesHook;
        # 2023-01-15: Support range >= 11 && < 16
        buildTargetLlvmPackages = pkgsBuildTarget.llvmPackages_15;
        llvmPackages = pkgs.llvmPackages_15;
      };
      ghc9102 = callPackage ../development/compilers/ghc/9.10.2.nix {
        bootPkgs =
          if stdenv.buildPlatform.isDarwin then
            # it seems like the GHC 9.6.* bindists are built with a different
            # toolchain than we are using (which I'm guessing from the fact
            # that 9.6.4 bindists pass linker flags our ld doesn't support).
            # With both 9.6.3 and 9.6.4 binary it is impossible to link against
            # the clock package (probably a hsc2hs problem).
            bb.packages.ghc963
          else
            bb.packages.ghc963Binary;
        inherit (buildPackages.python3Packages) sphinx;
        # Need to use apple's patched xattr until
        # https://github.com/xattr/xattr/issues/44 and
        # https://github.com/xattr/xattr/issues/55 are solved.
        inherit (buildPackages.darwin) xattr autoSignDarwinBinariesHook;
        # 2023-01-15: Support range >= 11 && < 16
        buildTargetLlvmPackages = pkgsBuildTarget.llvmPackages_15;
        llvmPackages = pkgs.llvmPackages_15;
      };
      ghc910 = compiler.ghc9102;
      ghc9121 = callPackage ../development/compilers/ghc/9.12.1.nix {
        bootPkgs =
          # No suitable bindist packaged yet
          bb.packages.ghc9102;
        inherit (buildPackages.python3Packages) sphinx;
        # Need to use apple's patched xattr until
        # https://github.com/xattr/xattr/issues/44 and
        # https://github.com/xattr/xattr/issues/55 are solved.
        inherit (buildPackages.darwin) xattr autoSignDarwinBinariesHook;
        # 2024-12-21: Support range >= 13 && < 20
        buildTargetLlvmPackages = pkgsBuildTarget.llvmPackages_19;
        llvmPackages = pkgs.llvmPackages_19;
      };
      ghc9122 = callPackage ../development/compilers/ghc/9.12.2.nix {
        bootPkgs =
          # No suitable bindist packaged yet
          bb.packages.ghc9102;
        inherit (buildPackages.python3Packages) sphinx;
        # Need to use apple's patched xattr until
        # https://github.com/xattr/xattr/issues/44 and
        # https://github.com/xattr/xattr/issues/55 are solved.
        inherit (buildPackages.darwin) xattr autoSignDarwinBinariesHook;
        # 2024-12-21: Support range >= 13 && < 20
        buildTargetLlvmPackages = pkgsBuildTarget.llvmPackages_19;
        llvmPackages = pkgs.llvmPackages_19;
      };
      ghc912 = compiler.ghc9122;
      ghcHEAD = callPackage ../development/compilers/ghc/head.nix {
        bootPkgs = bb.packages.ghc984Binary;
        inherit (buildPackages.python3Packages) sphinx;
        # Need to use apple's patched xattr until
        # https://github.com/xattr/xattr/issues/44 and
        # https://github.com/xattr/xattr/issues/55 are solved.
        inherit (buildPackages.darwin) xattr autoSignDarwinBinariesHook;
        # 2023-01-15: Support range >= 11 && < 16
        buildTargetLlvmPackages = pkgsBuildTarget.llvmPackages_18;
        llvmPackages = pkgs.llvmPackages_18;
      };

      # Starting from GHC 9, integer-{simple,gmp} is replaced by ghc-bignum
      # with "native" and "gmp" backends.
      native-bignum =
        let
          nativeBignumGhcNames = pkgs.lib.filter (name: !(builtins.elem name nativeBignumExcludes)) (
            pkgs.lib.attrNames compiler
          );
        in
        pkgs.recurseIntoAttrs (
          pkgs.lib.genAttrs nativeBignumGhcNames (
            name: compiler.${name}.override { enableNativeBignum = true; }
          )
        );
    }
    // pkgs.lib.optionalAttrs config.allowAliases {
      ghc810 = throw "'haskell.compiler.ghc810' has been removed."; # Added 2025-09-07
      ghc90 = throw "'haskell.compiler.ghc90' has been removed."; # Added 2025-09-07
      ghc92 = throw "'haskell.compiler.ghc92' has been removed."; # Added 2025-09-07
      ghcjs = throw "'haskell.compiler.ghcjs' has been removed. Please use 'pkgsCross.ghcjs' instead."; # Added 2025-09-06
      ghcjs810 = throw "'haskell.compiler.ghcjs810' has been removed. Please use 'pkgsCross.ghcjs' instead."; # Added 2025-09-06
      integer-simple = throw "All GHC versions with integer-simple support have been removed."; # Added 2025-09-07
    }
  );

  # Default overrides that are applied to all package sets.
  packageOverrides = self: super: { };

  # Always get compilers from `buildPackages`
  packages =
    let
      bh = buildPackages.haskell;
    in
    {
      ghc902Binary = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc902Binary;
        ghc = bh.compiler.ghc902Binary;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.0.x.nix { };
        packageSetConfig = bootstrapPackageSet;
      };
      ghc924Binary = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc924Binary;
        ghc = bh.compiler.ghc924Binary;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.2.x.nix { };
        packageSetConfig = bootstrapPackageSet;
      };
      ghc963Binary = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc963Binary;
        ghc = bh.compiler.ghc963Binary;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.6.x.nix { };
        packageSetConfig = bootstrapPackageSet;
      };
      ghc984Binary = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc984Binary;
        ghc = bh.compiler.ghc984Binary;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.8.x.nix { };
        packageSetConfig = bootstrapPackageSet;
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
      ghc967 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc967;
        ghc = bh.compiler.ghc967;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.6.x.nix { };
      };
      ghc96 = packages.ghc967;
      ghc984 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc984;
        ghc = bh.compiler.ghc984;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.8.x.nix { };
      };
      ghc98 = packages.ghc984;
      ghc9101 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc9101;
        ghc = bh.compiler.ghc9101;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.10.x.nix { };
      };
      ghc9102 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc9102;
        ghc = bh.compiler.ghc9102;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.10.x.nix { };
      };
      ghc910 = packages.ghc9102;
      ghc9121 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc9121;
        ghc = bh.compiler.ghc9121;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.12.x.nix { };
      };
      ghc9122 = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghc9122;
        ghc = bh.compiler.ghc9122;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.12.x.nix { };
      };
      ghc912 = packages.ghc9122;
      ghcHEAD = callPackage ../development/haskell-modules {
        buildHaskellPackages = bh.packages.ghcHEAD;
        ghc = bh.compiler.ghcHEAD;
        compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-9.14.x.nix { };
      };

      native-bignum =
        let
          nativeBignumGhcNames = pkgs.lib.filter (name: !(builtins.elem name nativeBignumExcludes)) (
            pkgs.lib.attrNames packages
          );
        in
        pkgs.lib.genAttrs nativeBignumGhcNames (
          name:
          packages.${name}.override {
            ghc = bh.compiler.native-bignum.${name};
            buildHaskellPackages = bh.packages.native-bignum.${name};
          }
        );
    }
    // pkgs.lib.optionalAttrs config.allowAliases {
      ghc810 = throw "'haskell.packages.ghc810' has been removed."; # Added 2025-09-07
      ghc90 = throw "'haskell.packages.ghc90' has been removed."; # Added 2025-09-07
      ghc92 = throw "'haskell.packages.ghc92' has been removed."; # Added 2025-09-07
      ghcjs = throw "'haskell.packages.ghcjs' has been removed. Please use 'pkgsCross.ghcjs' instead."; # Added 2025-09-06
      ghcjs810 = throw "'haskell.packages.ghcjs810' has been removed. Please use 'pkgsCross.ghcjs' instead."; # Added 2025-09-06
      integer-simple = throw "All GHC versions with integer-simple support have been removed."; # Added 2025-09-07
    };
}
