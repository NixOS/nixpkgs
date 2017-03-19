{ pkgs, callPackage, stdenv, buildPlatform, targetPlatform }:

let # These are attributes in compiler and packages that don't support integer-simple.
    integerSimpleExcludes = [
      "ghc6102Binary"
      "ghc704Binary"
      "ghc742Binary"
      "ghc6104"
      "ghc6123"
      "ghc704"
      "ghcjs"
      "ghcjsHEAD"
      "ghcCross"
      "jhc"
      "uhc"
      "integer-simple"
    ];
in rec {

  lib = import ../development/haskell-modules/lib.nix { inherit pkgs; };

  compiler = {

    ghc6102Binary = callPackage ../development/compilers/ghc/6.10.2-binary.nix { gmp = pkgs.gmp4; };
    ghc704Binary = callPackage ../development/compilers/ghc/7.0.4-binary.nix {
      gmp = pkgs.gmp4;
    };
    ghc742Binary = callPackage ../development/compilers/ghc/7.4.2-binary.nix {
      gmp = pkgs.gmp4;
    };

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
    ghc783 = callPackage ../development/compilers/ghc/7.8.3.nix {
      ghc = compiler.ghc742Binary;
    };
    ghc784 = callPackage ../development/compilers/ghc/7.8.4.nix {
      ghc = compiler.ghc742Binary;
    };
    ghc7102 = callPackage ../development/compilers/ghc/7.10.2.nix rec {
      bootPkgs = packages.ghc784;
      inherit (bootPkgs) hscolour;
    };
    ghc7103 = callPackage ../development/compilers/ghc/7.10.3.nix rec {
      bootPkgs = packages.ghc784;
      inherit (bootPkgs) hscolour;
    };
    ghc801 = callPackage ../development/compilers/ghc/8.0.1.nix rec {
      bootPkgs = packages.ghc7103;
      inherit (bootPkgs) hscolour;
      sphinx = pkgs.python27Packages.sphinx;
    };
    ghc802 = callPackage ../development/compilers/ghc/8.0.2.nix rec {
      bootPkgs = packages.ghc7103;
      inherit (bootPkgs) hscolour;
      sphinx = pkgs.python27Packages.sphinx;
    };
    ghcHEAD = callPackage ../development/compilers/ghc/head.nix rec {
      bootPkgs = packages.ghc7103;
      inherit (bootPkgs) alex happy;
      inherit buildPlatform targetPlatform;
      selfPkgs = packages.ghcHEAD;
    };
    ghcjs = packages.ghc7103.callPackage ../development/compilers/ghcjs {
      bootPkgs = packages.ghc7103;
    };
    ghcjsHEAD = packages.ghc802.callPackage ../development/compilers/ghcjs/head.nix {
      bootPkgs = packages.ghc802;
    };
    ghcHaLVM240 = callPackage ../development/compilers/halvm/2.4.0.nix rec {
      bootPkgs = packages.ghc802;
      inherit (bootPkgs) hscolour alex happy;
    };

    jhc = callPackage ../development/compilers/jhc {
      inherit (packages.ghc763) ghcWithPackages;
    };

    uhc = callPackage ../development/compilers/uhc/default.nix ({
      stdenv = pkgs.clangStdenv;
      inherit (pkgs.haskellPackages) ghcWithPackages;
    });

    # The integer-simple attribute set contains all the GHC compilers
    # build with integer-simple instead of integer-gmp.
    integer-simple =
      let integerSimpleGhcNames =
            pkgs.lib.filter (name: ! builtins.elem name integerSimpleExcludes)
                            (pkgs.lib.attrNames compiler);
          integerSimpleGhcs = pkgs.lib.genAttrs integerSimpleGhcNames
                                (name: compiler."${name}".override { enableIntegerSimple = true; });
      in pkgs.recurseIntoAttrs (integerSimpleGhcs // {
           ghcHEAD = integerSimpleGhcs.ghcHEAD.override { selfPkgs = packages.integer-simple.ghcHEAD; };
         });

  };

  packages = {

    # Support for this compiler is broken, because it can't deal with directory-based package databases.
    # ghc6104 = callPackage ../development/haskell-modules { ghc = compiler.ghc6104; };
    ghc6123 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc6123;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-6.12.x.nix { };
    };
    ghc704 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc704;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-7.0.x.nix { };
    };
    ghc722 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc722;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-7.2.x.nix { };
    };
    ghc742 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc742;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-7.4.x.nix { };
    };
    ghc763 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc763;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-7.6.x.nix { };
    };
    ghc783 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc783;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-7.8.x.nix { };
    };
    ghc784 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc784;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-7.8.x.nix { };
    };
    ghc7102 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc7102;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-7.10.x.nix { };
    };
    ghc7103 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc7103;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-7.10.x.nix { };
    };
    ghc801 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc801;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.0.x.nix { };
    };
    ghc802 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc802;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-8.0.x.nix { };
    };
    ghcHEAD = callPackage ../development/haskell-modules {
      ghc = compiler.ghcHEAD;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-head.nix { };
    };
    # TODO Support for multiple variants here
    ghcCross = callPackage ../development/haskell-modules {
      ghc = compiler.ghcHEAD.crossCompiler;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-head.nix { };
    };
    ghcjs = callPackage ../development/haskell-modules {
      ghc = compiler.ghcjs;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghcjs.nix { };
    };
    ghcjsHEAD = callPackage ../development/haskell-modules {
      ghc = compiler.ghcjsHEAD;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghcjs.nix { };
    };
    ghcHaLVM240 = callPackage ../development/haskell-modules {
      ghc = compiler.ghcHaLVM240;
      compilerConfig = callPackage ../development/haskell-modules/configuration-halvm-2.4.0.nix { };
    };

    # The integer-simple attribute set contains package sets for all the GHC compilers
    # using integer-simple instead of integer-gmp.
    integer-simple =
      let integerSimpleGhcNames =
            pkgs.lib.filter (name: ! builtins.elem name integerSimpleExcludes)
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
