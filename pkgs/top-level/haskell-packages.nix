{ pkgs, callPackage, stdenv }:

rec {

  lib = import ../development/haskell-modules/lib.nix { inherit pkgs; };

  compiler = {

    ghc6102Binary = callPackage ../development/compilers/ghc/6.10.2-binary.nix { gmp = pkgs.gmp4; };
    ghc704Binary = callPackage ../development/compilers/ghc/7.0.4-binary.nix ({ gmp = pkgs.gmp4; } // stdenv.lib.optionalAttrs stdenv.isDarwin {
      libiconv = pkgs.darwin.libiconv;
    });
    ghc742Binary = callPackage ../development/compilers/ghc/7.4.2-binary.nix ({ gmp = pkgs.gmp4; } // stdenv.lib.optionalAttrs stdenv.isDarwin {
      libiconv = pkgs.darwin.libiconv;
    });

    ghc6104 = callPackage ../development/compilers/ghc/6.10.4.nix { ghc = compiler.ghc6102Binary; };
    ghc6123 = callPackage ../development/compilers/ghc/6.12.3.nix { ghc = compiler.ghc6102Binary; };
    ghc704 = callPackage ../development/compilers/ghc/7.0.4.nix ({ ghc = compiler.ghc704Binary; } // stdenv.lib.optionalAttrs stdenv.isDarwin {
      libiconv = pkgs.darwin.libiconv;
    });
    ghc722 = callPackage ../development/compilers/ghc/7.2.2.nix ({ ghc = compiler.ghc704Binary; } // stdenv.lib.optionalAttrs stdenv.isDarwin {
      libiconv = pkgs.darwin.libiconv;
    });
    ghc742 = callPackage ../development/compilers/ghc/7.4.2.nix ({ ghc = compiler.ghc704Binary; } // stdenv.lib.optionalAttrs stdenv.isDarwin {
      libiconv = pkgs.darwin.libiconv;
    });
    ghc763 = callPackage ../development/compilers/ghc/7.6.3.nix ({ ghc = compiler.ghc704Binary; } // stdenv.lib.optionalAttrs stdenv.isDarwin {
      libiconv = pkgs.darwin.libiconv;
    });
    ghc784 = callPackage ../development/compilers/ghc/7.8.4.nix ({ ghc = compiler.ghc742Binary; } // stdenv.lib.optionalAttrs stdenv.isDarwin {
      libiconv = pkgs.darwin.libiconv;
    });
    ghc7102 = callPackage ../development/compilers/ghc/7.10.2.nix ({ ghc = compiler.ghc784; inherit (packages.ghc784) hscolour; } // stdenv.lib.optionalAttrs stdenv.isDarwin {
      libiconv = pkgs.darwin.libiconv;
    });
    ghcHEAD = callPackage ../development/compilers/ghc/head.nix ({ inherit (packages.ghc784) ghc alex happy; } // stdenv.lib.optionalAttrs stdenv.isDarwin {
      libiconv = pkgs.darwin.libiconv;
    });
    ghcNokinds = callPackage ../development/compilers/ghc/nokinds.nix ({ inherit (packages.ghc784) ghc alex happy; } // stdenv.lib.optionalAttrs stdenv.isDarwin {
      libiconv = pkgs.darwin.libiconv;
    });

    ghcjs = packages.ghc7102.callPackage ../development/compilers/ghcjs {
      ghc = compiler.ghc7102;
    };

    jhc = callPackage ../development/compilers/jhc {
      inherit (packages.ghc763) ghcWithPackages;
    };

    uhc = callPackage ../development/compilers/uhc/default.nix ({
      stdenv = pkgs.clangStdenv;
      inherit (pkgs.haskellPackages) ghcWithPackages;
    });

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
    ghc7102 = callPackage ../development/haskell-modules {
      ghc = compiler.ghc7102;
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghc-7.10.x.nix { };
    };
    ghcHEAD = callPackage ../development/haskell-modules {
      ghc = compiler.ghcHEAD;
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghc-head.nix { };
    };
    ghcNokinds = callPackage ../development/haskell-modules {
      ghc = compiler.ghcNokinds;
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghc-nokinds.nix { };
    };
    ghcjs = callPackage ../development/haskell-modules {
      ghc = compiler.ghcjs;
      packageSetConfig = callPackage ../development/haskell-modules/configuration-ghcjs.nix { };
    };

  };
}
