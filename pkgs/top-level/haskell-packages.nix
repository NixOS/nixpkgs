{ buildPackages, pkgs
, newScope, stdenv
, buildPlatform, targetPlatform
}:

let
  # These are attributes in compiler and packages that don't support integer-simple.
  integerSimpleExcludes = [
    "ghc6102Binary"
    "ghc704Binary"
    "ghc742Binary"
    "ghc784Binary"
    "ghc7103Binary"
    "ghc821Binary"
    "ghc6104"
    "ghc6123"
    "ghc704"
    "ghc763"
    "ghcjs"
    "ghcjsHEAD"
    "ghcCross"
    "uhc"
    "integer-simple"
  ];

  haskellLib = import ../development/haskell-modules/lib.nix {
    inherit (pkgs) lib;
    inherit pkgs;
  };

  callPackage = newScope { inherit haskellLib; };

in rec {
  lib = haskellLib;

  compiler = {

    ghc6102Binary = callPackage ../development/compilers/ghc/6.10.2-binary.nix {
      gmp = pkgs.gmp4;
    };
    ghc704Binary = callPackage ../development/compilers/ghc/7.0.4-binary.nix {
      gmp = pkgs.gmp4;
    };
    ghc742Binary = callPackage ../development/compilers/ghc/7.4.2-binary.nix {
      gmp = pkgs.gmp4;
    };
    ghc784Binary = callPackage ../development/compilers/ghc/7.8.4-binary.nix { };
    ghc7103Binary = callPackage ../development/compilers/ghc/7.10.3-binary.nix { };
    ghc821Binary = callPackage ../development/compilers/ghc/8.2.1-binary.nix { };

    ghc6104 = callPackage ../development/compilers/ghc/6.10.4.nix { ghc = compiler.ghc6102Binary; };
    ghc6123 = callPackage ../development/compilers/ghc/6.12.3.nix { ghc = compiler.ghc6102Binary; };
    ghc704 = callPackage ../development/compilers/ghc/7.0.4.nix {
      ghc = compiler.ghc704Binary;
    };
    ghc722 = callPackage ../development/compilers/ghc/7.2.2.nix {
      ghc = compiler.ghc704Binary;
    };
    ghc742 = callPackage ../development/compilers/ghc/7.4.2.nix {
      ghc = compiler.ghc704Binary;
    };
    ghc763 = callPackage ../development/compilers/ghc/7.6.3.nix {
      ghc = compiler.ghc704Binary;
    };
    ghc784 = callPackage ../development/compilers/ghc/7.8.4.nix {
      ghc = compiler.ghc742Binary;
    };
    ghc7103 = callPackage ../development/compilers/ghc/7.10.3.nix rec {
      bootPkgs = packages.ghc7103Binary;
      inherit (bootPkgs) hscolour;
    };
    ghc802 = callPackage ../development/compilers/ghc/8.0.2.nix rec {
      bootPkgs = packages.ghc7103Binary;
      inherit (bootPkgs) hscolour;
      sphinx = pkgs.python27Packages.sphinx;
    };
    ghc822 = callPackage ../development/compilers/ghc/8.2.2.nix rec {
      bootPkgs = packages.ghc821Binary;
      inherit (bootPkgs) hscolour alex happy;
      inherit buildPlatform targetPlatform;
      sphinx = pkgs.python3Packages.sphinx;
    };
    ghc841 = callPackage ../development/compilers/ghc/8.4.1.nix rec {
      bootPkgs = packages.ghc821Binary;
      inherit (bootPkgs) alex happy;
    };
    ghcHEAD = callPackage ../development/compilers/ghc/head.nix rec {
      bootPkgs = packages.ghc821Binary;
      inherit (bootPkgs) alex happy;
    };
    ghcjs = packages.ghc7103.callPackage ../development/compilers/ghcjs {
      bootPkgs = packages.ghc7103;
      inherit (pkgs) cabal-install;
    };
    ghcjsHEAD = packages.ghc802.callPackage ../development/compilers/ghcjs/head.nix {
      bootPkgs = packages.ghc802;
      inherit (pkgs) cabal-install;
    };
    ghcHaLVM240 = callPackage ../development/compilers/halvm/2.4.0.nix rec {
      bootPkgs = packages.ghc7103Binary;
      inherit (bootPkgs) hscolour alex happy;
    };

    uhc = callPackage ../development/compilers/uhc/default.nix ({
      stdenv = pkgs.clangStdenv;
      inherit (packages.ghc7103Binary) ghcWithPackages;
    });

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

  # Always get compilers from `buildPackages`
  packages = let inherit (buildPackages.haskell) compiler; in {

    ghc7103 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc7103;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-7.10.x.nix { };
    };
    ghc7103Binary = callPackage ../development/haskell-modules {
      ghc = compiler.ghc7103Binary;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-7.10.x.nix { };
    };
    ghc802 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc802;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.0.x.nix { };
    };
    ghc822 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc822;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.2.x.nix { };
    };
    ghc821Binary = callPackage ../development/haskell-modules {
      ghc = compiler.ghc821Binary;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.2.x.nix { };
    };
    ghc841 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc841;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.4.x.nix { };
    };
    ghcHEAD = callPackage ../development/haskell-modules {
      ghc = compiler.ghcHEAD;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-head.nix { };
    };
    ghcjs = callPackage ../development/haskell-modules {
      ghc = compiler.ghcjs;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-7.10.x.nix { };
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghcjs.nix { };
    };
    ghcjsHEAD = callPackage ../development/haskell-modules {
      ghc = compiler.ghcjsHEAD;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.0.x.nix { };
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghcjs.nix { };
    };
    ghcHaLVM240 = callPackage ../development/haskell-modules {
      ghc = compiler.ghcHaLVM240;
      compilerConfig = callPackage ../development/haskell-modules/configuration-halvm-2.4.0.nix { };
    };

    # The integer-simple attribute set contains package sets for all the GHC compilers
    # using integer-simple instead of integer-gmp.
    integer-simple = let
      integerSimpleGhcNames = pkgs.lib.filter
        (name: ! builtins.elem name integerSimpleExcludes)
        (pkgs.lib.attrNames packages);
    in pkgs.lib.genAttrs integerSimpleGhcNames (name: packages."${name}".override {
      ghc = compiler.integer-simple."${name}";
      overrides = _self : _super : {
        integer-simple = null;
        integer-gmp = null;
      };
    });

  };
}
