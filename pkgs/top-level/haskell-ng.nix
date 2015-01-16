{ pkgs, callPackage }:

rec {

  lib = import ../development/haskell-modules/lib.nix { inherit pkgs; };

  compiler = {

    ghc6102Binary = callPackage ../development/compilers/ghc/6.10.2-binary.nix { gmp = pkgs.gmp4; };
    ghc704Binary = callPackage ../development/compilers/ghc/7.0.4-binary.nix { gmp = pkgs.gmp4; };
    ghc742Binary = callPackage ../development/compilers/ghc/7.4.2-binary.nix { gmp = pkgs.gmp4; };

    ghc6104 = callPackage ../development/compilers/ghc/6.10.4.nix { ghc = compiler.ghc6102Binary; gmp = pkgs.gmp.override { withStatic = true; }; };
    ghc6123 = callPackage ../development/compilers/ghc/6.12.3.nix { ghc = compiler.ghc6102Binary; gmp = pkgs.gmp.override { withStatic = true; }; };
    ghc704 = callPackage ../development/compilers/ghc/7.0.4.nix { ghc = compiler.ghc704Binary; gmp = pkgs.gmp.override { withStatic = true; }; };
    ghc722 = callPackage ../development/compilers/ghc/7.2.2.nix { ghc = compiler.ghc704Binary; gmp = pkgs.gmp.override { withStatic = true; }; };
    ghc742 = callPackage ../development/compilers/ghc/7.4.2.nix { ghc = compiler.ghc704Binary; gmp = pkgs.gmp.override { withStatic = true; }; };
    ghc763 = callPackage ../development/compilers/ghc/7.6.3.nix { ghc = compiler.ghc704Binary; gmp = pkgs.gmp.override { withStatic = true; }; };
    ghc784 = callPackage ../development/compilers/ghc/7.8.4.nix { ghc = compiler.ghc742Binary; gmp = pkgs.gmp.override { withStatic = true; }; };
    ghcHEAD = callPackage ../development/compilers/ghc/head.nix { inherit (packages.ghc784) ghc alex happy; };
    ghc = compiler.ghc784;

  };

  packages = {

    ghc6104 = callPackage ../development/haskell-modules { ghc = compiler.ghc6104; };
    ghc6123 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc6123;
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghc-6.12.x.nix { };
    };
    ghc704 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc704;
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghc-7.0.x.nix { };
    };
    ghc722 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc722;
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghc-7.2.x.nix { };
    };
    ghc742 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc742;
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghc-7.4.x.nix { };
    };
    ghc763 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc763;
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghc-7.6.x.nix { };
    };

    ghc784 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc784;
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghc-7.8.x.nix { };
    };

    ghcHEAD = callPackage ../development/haskell-modules {
      ghc = compiler.ghcHEAD;
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghc-7.9.x.nix { };
    };

    ghcjs = callPackage ../development/haskell-modules {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghcjs.nix { };
    };

  };
}
