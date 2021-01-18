{ buildPackages, pkgs, newScope, stdenv }:

let
  inherit (pkgs.lib) listToAttrs optionalString recurseIntoAttrs mapAttrs filterAttrs;

  # These are attributes in compiler and packages that don't support integer-simple.
  # TODO remove when packages is refactor like compiler
  integerSimpleExcludes = [
    "ghc822Binary"
    "ghc865Binary"
    "ghc8102Binary"
    "ghc8102BinaryMinimal"
    "ghcjs"
    "ghcjs86"
    "integer-simple"
    "native-bignum"
    "ghcHEAD"
  ];

  # TODO remove when packages is refactor like compiler
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

  # NOTE: Attr names must not depend on derivations, to avoid forcing all
  #       compiler derivations when evaluating pkgs.haskell.compiler to WHNF.
  #       So this is why we can't reuse compiler.version
  compilerVersions = [
    {
      name = "ghc";
      major = 8;
      minor = 2;
      patch = 2;
      suffix = "Binary";
      supportsIntegerSimple = false;
      compiler = callPackage ../development/compilers/ghc/8.2.2-binary.nix { };
    }
    {
      name = "ghc";
      major = 8;
      minor = 6;
      patch = 5;
      suffix = "Binary";
      supportsIntegerSimple = false;
      compiler = callPackage ../development/compilers/ghc/8.6.5-binary.nix { };
    }
    {
      name = "ghc";
      major = 8;
      minor = 10;
      patch = 2;
      suffix = "Binary";
      supportsIntegerSimple = false;
      compiler = callPackage ../development/compilers/ghc/8.10.2-binary.nix {
        llvmPackages = pkgs.llvmPackages_9;
      };
    }
    {
      name = "ghc";
      major = 8;
      minor = 10;
      patch = 2;
      suffix = "BinaryMinimal";
      supportsIntegerSimple = false;
      compiler = callPackage ../development/compilers/ghc/8.10.2-binary.nix {
        llvmPackages = pkgs.llvmPackages_9;
        minimal = true;
      };
    }
    
    {
      name = "ghc";
      major = 8;
      minor = 6;
      patch = 5;
      suffix = "";
      supportsIntegerSimple = true;
      compiler = callPackage ../development/compilers/ghc/8.6.5.nix {
        bootPkgs = packages.ghc822Binary;
        inherit (buildPackages.python3Packages) sphinx;
        buildLlvmPackages = buildPackages.llvmPackages_6;
        llvmPackages = pkgs.llvmPackages_6;
      };
    }
    {
      name = "ghc";
      major = 8;
      minor = 8;
      patch = 2;
      suffix = "";
      supportsIntegerSimple = true;
      compiler = callPackage ../development/compilers/ghc/8.8.2.nix {
        bootPkgs = packages.ghc865Binary;
        inherit (buildPackages.python3Packages) sphinx;
        buildLlvmPackages = buildPackages.llvmPackages_7;
        llvmPackages = pkgs.llvmPackages_7;
      };
    }
    {
      name = "ghc";
      major = 8;
      minor = 8;
      patch = 3;
      suffix = "";
      supportsIntegerSimple = true;
      compiler = callPackage ../development/compilers/ghc/8.8.3.nix {
        bootPkgs = packages.ghc865Binary;
        inherit (buildPackages.python3Packages) sphinx;
        buildLlvmPackages = buildPackages.llvmPackages_7;
        llvmPackages = pkgs.llvmPackages_7;
      };
    }
    {
      name = "ghc";
      major = 8;
      minor = 8;
      patch = 4;
      suffix = "";
      supportsIntegerSimple = true;
      compiler = callPackage ../development/compilers/ghc/8.8.4.nix {
        # aarch64 ghc865Binary gets SEGVs due to haskell#15449 or similar
        bootPkgs = if stdenv.isAarch64 then
            packages.ghc8102BinaryMinimal
          else
            packages.ghc865Binary;
        inherit (buildPackages.python3Packages) sphinx;
        buildLlvmPackages = buildPackages.llvmPackages_7;
        llvmPackages = pkgs.llvmPackages_7;
      };
    }
    {
      name = "ghc";
      major = 8;
      minor = 10;
      patch = 1;
      suffix = "";
      supportsIntegerSimple = true;
      compiler = callPackage ../development/compilers/ghc/8.10.1.nix {
        bootPkgs = packages.ghc865Binary;
        inherit (buildPackages.python3Packages) sphinx;
        buildLlvmPackages = buildPackages.llvmPackages_9;
        llvmPackages = pkgs.llvmPackages_9;
      };
    }
    {
      name = "ghc";
      major = 8;
      minor = 10;
      patch = 2;
      suffix = "";
      supportsIntegerSimple = true;
      compiler = callPackage ../development/compilers/ghc/8.10.2.nix {
        # aarch64 ghc865Binary gets SEGVs due to haskell#15449 or similar
        bootPkgs = if stdenv.isAarch64 || stdenv.isAarch32 then
            packages.ghc8102BinaryMinimal
          else
            packages.ghc865Binary;
        inherit (buildPackages.python3Packages) sphinx;
        buildLlvmPackages = buildPackages.llvmPackages_9;
        llvmPackages = pkgs.llvmPackages_9;
      };
    }
    {
      name = "ghc";
      major = 8;
      minor = 10;
      patch = 3;
      suffix = "";
      supportsIntegerSimple = true;
      compiler = callPackage ../development/compilers/ghc/8.10.3.nix {
        # aarch64 ghc865Binary gets SEGVs due to haskell#15449 or similar
        bootPkgs = if stdenv.isAarch64 || stdenv.isAarch32 then
            packages.ghc8102BinaryMinimal
          else
            packages.ghc865Binary;
        inherit (buildPackages.python3Packages) sphinx;
        buildLlvmPackages = buildPackages.llvmPackages_9;
        llvmPackages = pkgs.llvmPackages_9;
      };
    }
    {
      name = "ghc";
      major = 9;
      minor = 0;
      patch = 1;
      suffix = "";
      supportsIntegerSimple = false;
      compiler = callPackage ../development/compilers/ghc/9.0.1.nix {
        bootPkgs = packages.ghc8102Binary;
        inherit (buildPackages.python3Packages) sphinx;
        buildLlvmPackages = buildPackages.llvmPackages_10;
        llvmPackages = pkgs.llvmPackages_10;
      };
    }
    {
      name = "ghc";
      major = "";
      minor = "";
      patch = "";
      suffix = "HEAD";
      supportsIntegerSimple = false;
      supportsNativeBignum = true;
      compiler = callPackage ../development/compilers/ghc/head.nix {
        bootPkgs = packages.ghc883; # no binary yet
        inherit (buildPackages.python3Packages) sphinx;
        buildLlvmPackages = buildPackages.llvmPackages_10;
        llvmPackages = pkgs.llvmPackages_10;
        libffi = pkgs.libffi;
      };
    }
    {
      name = "ghcjs";
      major = 8;
      minor = 6;
      patch = "";
      suffix = "";
      supportsIntegerSimple = false;
      compiler = callPackage ../development/compilers/ghcjs-ng {
        bootPkgs = packages.ghc865;
        ghcjsSrcJson = ../development/compilers/ghcjs-ng/8.6/git.json;
        stage0 = ../development/compilers/ghcjs-ng/8.6/stage0.nix;
        ghcjsDepOverrides = callPackage ../development/compilers/ghcjs-ng/8.6/dep-overrides.nix {};
      };
    }
  ];

  shorthandAttrs = listToAttrs (map (attrs@{ name, major, minor, patch, suffix, compiler, ... }: {
    name = "${name}${toString major}${toString minor}${toString patch}${toString suffix}";
    value = attrs;
  }) compilerVersions);

  toFullName = { name, major, minor, patch, suffix }:
    "${name}-${toString major}_${toString minor}${optionalString (patch != "") "_"}${toString patch}${optionalString (suffix != "") "-"}${toString suffix}";

  fullAttrs = listToAttrs (map (attrs@{ name, major, minor, patch, suffix, compiler, ... }: {
    name = toFullName { inherit name major minor patch suffix; };
    value = attrs;
  }) compilerVersions);

  compilerVersionAttrs = shorthandAttrs // fullAttrs;

  aliases = {
    ghcjs = compiler.ghcjs86;

    # The integer-simple attribute set contains all the GHC compilers
    # build with integer-simple instead of integer-gmp.
    integer-simple =
      recurseIntoAttrs
        (mapAttrs (k: v: v.compiler)
          (filterAttrs (k: v: v.supportsIntegerSimple)
            compilerVersionAttrs));

    # Starting from GHC 9, integer-{simple,gmp} is replaced by ghc-bignum
    # with "native" and "gmp" backends.
    native-bignum =
      recurseIntoAttrs
        (mapAttrs (k: v: v.compiler)
          (filterAttrs (k: v: v.supportsNativeBignum or false)
            compilerVersionAttrs));
  };

  # Always get compilers from `buildPackages`
  packages' = let bh = buildPackages.haskell; in {

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
    ghc8102 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc8102;
      ghc = bh.compiler.ghc8102;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.10.x.nix { };
    };
    ghc8103 = callPackage ../development/haskell-modules {
      buildHaskellPackages = bh.packages.ghc8103;
      ghc = bh.compiler.ghc8103;
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

in {
  lib = haskellLib;

  # Default overrides that are applied to all package sets.
  packageOverrides = self : super : {};

  compiler = mapAttrs (k: v: v.compiler) compilerVersionAttrs // aliases;

  packages = packages';
}
