{ buildPackages, pkgs
, newScope
, stdenv
}:

let
  # These are attributes in compiler for which we can build special
  # ghc variants like integer-simple, DWARF etc.
  # The entries in here must only have 1 level (they cannot be package
  # sets like e.g. `integer-simple`).
  normalGhcCompilers = [
    "ghc822"
    "ghc844"
    "ghc861"
    "ghc862"
    "ghc863"
    "ghcHEAD"
  ];

  # These are attributes in compiler and packages that don't support integer-simple.
  integerSimpleExcludes = [
    "ghc844"
  ];

  dwarfExcludes = [
    # GHC 8.2.2 can't be built with DWARF support due to
    # https://github.com/NixOS/nixpkgs/pull/52255#issuecomment-447611164
    "ghc822"
    # At the time of writing, ghcHEAD's version is too old
    # (ghc-8.5.20180118) and thus suffers from the same problem as
    # https://github.com/NixOS/nixpkgs/pull/52255#issuecomment-447611164.
    # We can remove this as soon as we have one of the 8.8 series.
    "ghcHEAD"
  ];

  integerSimpleGhcNames = pkgs.lib.filter
    (name: ! builtins.elem name integerSimpleExcludes)
    normalGhcCompilers;

  dwarfGhcNames = pkgs.lib.filter
    (name: ! builtins.elem name dwarfExcludes)
    normalGhcCompilers;

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
      bootPkgs = packages.ghc822;
      inherit (buildPackages.python3Packages) sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_6;
      llvmPackages = pkgs.llvmPackages_6;
    };
    ghc862 = callPackage ../development/compilers/ghc/8.6.2.nix {
      bootPkgs = packages.ghc822;
      inherit (buildPackages.python3Packages) sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_6;
      llvmPackages = pkgs.llvmPackages_6;
    };
    ghc863 = callPackage ../development/compilers/ghc/8.6.3.nix {
      bootPkgs = packages.ghc822;
      inherit (buildPackages.python3Packages) sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_6;
      llvmPackages = pkgs.llvmPackages_6;
    };
    # When adding a new compiler here, don't forget to update
    # normalGhcCompilers.
    ghcHEAD = callPackage ../development/compilers/ghc/head.nix {
      bootPkgs = packages.ghc822Binary;
      inherit (buildPackages.python3Packages) sphinx;
      buildLlvmPackages = buildPackages.llvmPackages_5;
      llvmPackages = pkgs.llvmPackages_5;
    };
    ghcjs = compiler.ghcjs84;
    ghcjs82 = callPackage ../development/compilers/ghcjs-ng {
      bootPkgs = packages.ghc822;
      ghcjsSrcJson = ../development/compilers/ghcjs-ng/8.2/git.json;
      stage0 = ../development/compilers/ghcjs-ng/8.2/stage0.nix;
    };
    ghcjs84 = callPackage ../development/compilers/ghcjs-ng {
      bootPkgs = packages.ghc844;
      ghcjsSrcJson = ../development/compilers/ghcjs-ng/8.4/git.json;
      stage0 = ../development/compilers/ghcjs-ng/8.4/stage0.nix;
      ghcjsDepOverrides = callPackage ../development/compilers/ghcjs-ng/8.4/dep-overrides.nix {};
    };

    # The integer-simple attribute set contains all the GHC compilers
    # built with integer-simple instead of integer-gmp.
    integer-simple = pkgs.recurseIntoAttrs (pkgs.lib.genAttrs
      integerSimpleGhcNames
      (name: compiler."${name}".override { enableIntegerSimple = true; }));

    # The dwarf attribute set contains all the GHC compilers
    # built with DWARF support.
    # We don't do it on Darwin because that doesn't have the required
    # elfutils.
    dwarf = if stdenv.isDarwin then {} else
      pkgs.recurseIntoAttrs (pkgs.lib.genAttrs
        dwarfGhcNames
        (name: compiler."${name}".override { enableDwarf = true; }));
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
    ghc822 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc822;
      ghc = bh.compiler.ghc822;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.2.x.nix { };
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
    integer-simple = pkgs.lib.genAttrs integerSimpleGhcNames (name: packages."${name}".override {
      ghc = bh.compiler.integer-simple."${name}";
      buildHaskellPackages = bh.packages.integer-simple."${name}";
      overrides = _self : _super : {
        # Usually, integer-simple is a normal package that you can build.
        # In this package set, it is a ghc-bundled library, so we
        # set it to `null` (ghc-bundled libraries are always `null`
        # in `haskellPackages` package sets).
        integer-simple = null;
        # Get rid of `integer-gmp` as a safety measure to notice
        # when anything hard-depends on it.
        integer-gmp = null;
      };
    });

    # The dwarf attribute set contains package sets for all the GHC compilers
    # with all packages compiled with `-g` debugging info.
    dwarf = pkgs.lib.genAttrs normalGhcCompilers (name: packages."${name}".override {
      ghc = bh.compiler.dwarf."${name}";
      buildHaskellPackages = bh.packages.dwarf."${name}";
      overrides = self : super : {
        # Override the mkDerivation function so that the GHC flags that
        # are needed for debugging symbols are passed to all Cabal invocations.
        mkDerivation = old: super.mkDerivation (old // {
          configureFlags = (old.configureFlags or []) ++ [
            "--enable-debug-info=3"
            "--disable-library-stripping"
            "--disable-executable-stripping"
          ];
          # Disable nixpkgs' own stripping.
          dontStrip = true;
        });
      };
    });
  };
}
