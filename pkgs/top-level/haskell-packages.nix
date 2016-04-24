{ pkgs, callPackage, stdenv }:

rec {

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
    };
    ghcHEAD = callPackage ../development/compilers/ghc/head.nix rec {
      bootPkgs = packages.ghc784;
      inherit (bootPkgs) alex happy;
    };
    ghcNokinds = callPackage ../development/compilers/ghc/nokinds.nix rec {
      bootPkgs = packages.ghc784;
      inherit (bootPkgs) alex happy;
    };

    ghcjs = packages.ghc7103.callPackage ../development/compilers/ghcjs {
      bootPkgs = packages.ghc7103;
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
    ghcHEAD = callPackage ../development/haskell-modules {
      ghc = compiler.ghcHEAD;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-head.nix { };
    };
    ghcNokinds = callPackage ../development/haskell-modules {
      ghc = compiler.ghcNokinds;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghc-nokinds.nix { };
    };
    ghcjs = callPackage ../development/haskell-modules {
      ghc = compiler.ghcjs;
      compilerConfig = callPackage ../development/haskell-modules/configuration-ghcjs.nix { };
    };

    lts-0_0 = packages.ghc783.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-0.0.nix { };
    };
    lts-0_1 = packages.ghc783.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-0.1.nix { };
    };
    lts-0_2 = packages.ghc783.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-0.2.nix { };
    };
    lts-0_3 = packages.ghc783.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-0.3.nix { };
    };
    lts-0_4 = packages.ghc783.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-0.4.nix { };
    };
    lts-0_5 = packages.ghc783.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-0.5.nix { };
    };
    lts-0_6 = packages.ghc783.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-0.6.nix { };
    };
    lts-0_7 = packages.ghc783.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-0.7.nix { };
    };
    lts-0 = packages.lts-0_7;

    lts-1_0 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-1.0.nix { };
    };
    lts-1_1 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-1.1.nix { };
    };
    lts-1_2 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-1.2.nix { };
    };
    lts-1_4 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-1.4.nix { };
    };
    lts-1_5 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-1.5.nix { };
    };
    lts-1_7 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-1.7.nix { };
    };
    lts-1_8 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-1.8.nix { };
    };
    lts-1_9 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-1.9.nix { };
    };
    lts-1_10 =packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-1.10.nix { };
    };
    lts-1_11 =packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-1.11.nix { };
    };
    lts-1_12 =packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-1.12.nix { };
    };
    lts-1_13 =packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-1.13.nix { };
    };
    lts-1_14 =packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-1.14.nix { };
    };
    lts-1_15 =packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-1.15.nix { };
    };
    lts-1 = packages.lts-1_15;

    lts-2_0 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-2.0.nix { };
    };
    lts-2_1 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-2.1.nix { };
    };
    lts-2_2 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-2.2.nix { };
    };
    lts-2_3 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-2.3.nix { };
    };
    lts-2_4 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-2.4.nix { };
    };
    lts-2_5 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-2.5.nix { };
    };
    lts-2_6 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-2.6.nix { };
    };
    lts-2_7 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-2.7.nix { };
    };
    lts-2_8 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-2.8.nix { };
    };
    lts-2_9 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-2.9.nix { };
    };
    lts-2_10 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-2.10.nix { };
    };
    lts-2_11 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-2.11.nix { };
    };
    lts-2_12 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-2.12.nix { };
    };
    lts-2_13 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-2.13.nix { };
    };
    lts-2_14 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-2.14.nix { };
    };
    lts-2_15 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-2.15.nix { };
    };
    lts-2_16 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-2.16.nix { };
    };
    lts-2_17 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-2.17.nix { };
    };
    lts-2_18 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-2.18.nix { };
    };
    lts-2_19 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-2.19.nix { };
    };
    lts-2_20 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-2.20.nix { };
    };
    lts-2_21 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-2.21.nix { };
    };
    lts-2_22 = packages.ghc784.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-2.22.nix { };
    };
    lts-2 = packages.lts-2_22;

    lts-3_0 = packages.ghc7102.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-3.0.nix { };
    };
    lts-3_1 = packages.ghc7102.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-3.1.nix { };
    };
    lts-3_2 = packages.ghc7102.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-3.2.nix { };
    };
    lts-3_3 = packages.ghc7102.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-3.3.nix { };
    };
    lts-3_4 = packages.ghc7102.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-3.4.nix { };
    };
    lts-3_5 = packages.ghc7102.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-3.5.nix { };
    };
    lts-3_6 = packages.ghc7102.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-3.6.nix { };
    };
    lts-3_7 = packages.ghc7102.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-3.7.nix { };
    };
    lts-3_8 = packages.ghc7102.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-3.8.nix { };
    };
    lts-3_9 = packages.ghc7102.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-3.9.nix { };
    };
    lts-3_10 = packages.ghc7102.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-3.10.nix { };
    };
    lts-3_11 = packages.ghc7102.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-3.11.nix { };
    };
    lts-3_12 = packages.ghc7102.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-3.12.nix { };
    };
    lts-3_13 = packages.ghc7102.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-3.13.nix { };
    };
    lts-3_14 = packages.ghc7102.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-3.14.nix { };
    };
    lts-3_15 = packages.ghc7102.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-3.15.nix { };
    };
    lts-3_16 = packages.ghc7102.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-3.16.nix { };
    };
    lts-3_17 = packages.ghc7102.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-3.17.nix { };
    };
    lts-3_18 = packages.ghc7102.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-3.18.nix { };
    };
    lts-3_19 = packages.ghc7102.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-3.19.nix { };
    };
    lts-3_20 = packages.ghc7102.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-3.20.nix { };
    };
    lts-3 = packages.lts-3_20;

    lts-4_0 = packages.ghc7103.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-4.0.nix { };
    };
    lts-4_1 = packages.ghc7103.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-4.1.nix { };
    };
    lts-4_2 = packages.ghc7103.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-4.2.nix { };
    };
    lts-4 = packages.lts-4_2;

    lts-5_0 = packages.ghc7103.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-5.0.nix { };
    };
    lts-5_1 = packages.ghc7103.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-5.1.nix { };
    };
    lts-5_2 = packages.ghc7103.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-5.2.nix { };
    };
    lts-5_3 = packages.ghc7103.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-5.3.nix { };
    };
    lts-5_4 = packages.ghc7103.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-5.4.nix { };
    };
    lts-5_5 = packages.ghc7103.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-5.5.nix { };
    };
    lts-5_6 = packages.ghc7103.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-5.6.nix { };
    };
    lts-5_7 = packages.ghc7103.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-5.7.nix { };
    };
    lts-5_8 = packages.ghc7103.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-5.8.nix { };
    };
    lts-5_9 = packages.ghc7103.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-5.9.nix { };
    };
    lts-5_10 = packages.ghc7103.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-5.10.nix { };
    };
    lts-5_11 = packages.ghc7103.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-5.11.nix { };
    };
    lts-5_12 = packages.ghc7103.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-5.12.nix { };
    };
    lts-5_13 = packages.ghc7103.override {
      packageSetConfig = callPackage ../development/haskell-modules/configuration-lts-5.13.nix { };
    };
    lts-5 = packages.lts-5_13;

    lts = packages.lts-5;
  };
}
