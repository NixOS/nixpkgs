# Haskell / GHC infrastructure in Nixpkgs
#
# In this file, we
#
#    * define sets of default package versions for each GHC compiler version,
#    * associate GHC versions with bootstrap compiler versions and package defaults.
#
# The actual Haskell packages are composed in haskell-packages.nix. There is
# more documentation in there.

{ makeOverridable, lowPrio, stdenv, pkgs, newScope, config, callPackage } : rec {

  # Preferences functions.
  #
  # Change these if you want to change the default versions of packages being used
  # for a particular GHC version.

  ghcHEADPrefs =
    self : self.haskellPlatformArgs_future self // {
      haskellPlatform = null;
      extensibleExceptions = self.extensibleExceptions_0_1_1_4;
      cabalInstall_1_18_0_2 = self.cabalInstall_1_18_0_2.override { Cabal = null; };
      cabalInstall = self.cabalInstall_1_18_0_2.override { Cabal = null; };
    };

  ghc763Prefs =
    self : self.haskellPlatformArgs_2013_2_0_0 self // {
      haskellPlatform = self.haskellPlatform_2013_2_0_0;
      extensibleExceptions = self.extensibleExceptions_0_1_1_4;
    };

  ghc742Prefs =
    self : self.haskellPlatformArgs_2012_4_0_0 self // {
      haskellPlatform = self.haskellPlatform_2012_4_0_0;
      cabalInstall_1_16_0_2 = self.cabalInstall_1_16_0_2.override { Cabal = self.Cabal_1_16_0_3; };
      bmp = self.bmp_1_2_2_1;
    };

  ghc741Prefs =
    self : self.haskellPlatformArgs_2012_2_0_0 self // {
      haskellPlatform = self.haskellPlatform_2012_2_0_0;
      cabalInstall_1_16_0_2 = self.cabalInstall_1_16_0_2.override { Cabal = self.Cabal_1_16_0_3; };
      bmp = self.bmp_1_2_2_1;
    };

  ghc722Prefs =
    self : self.haskellPlatformArgs_2012_2_0_0 self // {
      haskellPlatform = self.haskellPlatform_2012_2_0_0;
      deepseq = self.deepseq_1_3_0_1;
      cabalInstall_1_16_0_2 = self.cabalInstall_1_16_0_2.override { Cabal = self.Cabal_1_16_0_3; };
      bmp = self.bmp_1_2_2_1;
    };

  ghc721Prefs = ghc722Prefs;

  ghc704Prefs =
    self : self.haskellPlatformArgs_2011_4_0_0 self // {
      haskellPlatform = self.haskellPlatform_2011_4_0_0;
      cabalInstall_0_14_0 = self.cabalInstall_0_14_0.override { Cabal = self.Cabal_1_14_0; };
      cabalInstall_1_16_0_2 = self.cabalInstall_1_16_0_2.override { Cabal = self.Cabal_1_16_0_3; };
      monadPar = self.monadPar_0_1_0_3;
      jailbreakCabal = self.jailbreakCabal.override { Cabal = self.disableTest self.Cabal_1_14_0; };
      prettyShow = self.prettyShow_1_2;
      bmp = self.bmp_1_2_2_1;
      Cabal_1_18_1_2 = self.Cabal_1_18_1_2.override { deepseq = self.deepseq_1_3_0_2; };
    };

  ghc703Prefs =
    self : self.haskellPlatformArgs_2011_2_0_1 self // {
      haskellPlatform = self.haskellPlatform_2011_2_0_1;
      cabalInstall_0_14_0 = self.cabalInstall_0_14_0.override { Cabal = self.Cabal_1_14_0; zlib = self.zlib_0_5_3_3; };
      cabalInstall_1_16_0_2 = self.cabalInstall_1_16_0_2.override { Cabal = self.Cabal_1_16_0_3; zlib = self.zlib_0_5_3_3; };
      monadPar = self.monadPar_0_1_0_3;
      jailbreakCabal = self.jailbreakCabal.override { Cabal = self.disableTest self.Cabal_1_14_0; };
      prettyShow = self.prettyShow_1_2;
      bmp = self.bmp_1_2_2_1;
      Cabal_1_18_1_2 = self.Cabal_1_18_1_2.override { deepseq = self.deepseq_1_3_0_2; };
    };

  ghc702Prefs = ghc701Prefs;

  ghc701Prefs =
    self : self.haskellPlatformArgs_2011_2_0_0 self // {
      haskellPlatform = self.haskellPlatform_2011_2_0_0;
      cabalInstall_0_14_0 = self.cabalInstall_0_14_0.override { Cabal = self.Cabal_1_14_0; zlib = self.zlib_0_5_3_3; };
      cabalInstall_1_16_0_2 = self.cabalInstall_1_16_0_2.override { Cabal = self.Cabal_1_16_0_3; zlib = self.zlib_0_5_3_3; };
      monadPar = self.monadPar_0_1_0_3;
      jailbreakCabal = self.jailbreakCabal.override { Cabal = self.disableTest self.Cabal_1_14_0; };
      prettyShow = self.prettyShow_1_2;
      bmp = self.bmp_1_2_2_1;
      Cabal_1_18_1_2 = self.Cabal_1_18_1_2.override { deepseq = self.deepseq_1_3_0_2; };
    };

  ghc6123Prefs = ghc6122Prefs;

  ghc6122Prefs =
    self : self.haskellPlatformArgs_2010_2_0_0 self // {
      haskellPlatform = self.haskellPlatform_2010_2_0_0;
      mtl1 = self.mtl_1_1_0_2;
      monadPar = self.monadPar_0_1_0_3;
      deepseq = self.deepseq_1_1_0_2;
      # deviating from Haskell platform here, to make some packages (notably statistics) compile
      jailbreakCabal = self.jailbreakCabal.override { Cabal = self.disableTest self.Cabal_1_14_0; };
      cabal2nix = self.cabal2nix.override { Cabal = self.Cabal_1_16_0_3; hackageDb = self.hackageDb.override { Cabal = self.Cabal_1_16_0_3; }; };
      bmp = self.bmp_1_2_2_1;
      cabalInstall_1_16_0_2 = self.cabalInstall_1_16_0_2.override {
        Cabal = self.Cabal_1_16_0_3; zlib = self.zlib_0_5_3_3;
        mtl = self.mtl_2_1_2;
        HTTP = self.HTTP_4000_1_1.override { mtl = self.mtl_2_1_2; };
      };
    };

  ghc6121Prefs =
    self : self.haskellPlatformArgs_2010_1_0_0 self // {
      haskellPlatform = self.haskellPlatform_2010_1_0_0;
      mtl1 = self.mtl_1_1_0_2;
      extensibleExceptions = self.extensibleExceptions_0_1_1_0;
      deepseq = self.deepseq_1_1_0_2;
      monadPar = self.monadPar_0_1_0_3;
      # deviating from Haskell platform here, to make some packages (notably statistics) compile
      jailbreakCabal = self.jailbreakCabal.override { Cabal = self.disableTest self.Cabal_1_14_0; };
      cabal2nix = self.cabal2nix.override { Cabal = self.Cabal_1_16_0_3; hackageDb = self.hackageDb.override { Cabal = self.Cabal_1_16_0_3; }; };
      bmp = self.bmp_1_2_2_1;
      cabalInstall_1_16_0_2 = self.cabalInstall_1_16_0_2.override {
        Cabal = self.Cabal_1_16_0_3;
        zlib = self.zlib_0_5_3_3;
        mtl = self.mtl_2_1_2;
        HTTP = self.HTTP_4000_1_1.override { mtl = self.mtl_2_1_2; };
      };
    };

  ghc6104Prefs =
    self : self.haskellPlatformArgs_2009_2_0_2 self // {
      haskellPlatform = self.haskellPlatform_2009_2_0_2;
      mtl = self.mtl_1_1_0_2;
      mtl1 = self.mtl_1_1_0_2;
      extensibleExceptions = self.extensibleExceptions_0_1_1_0;
      text = self.text_0_11_0_6;
      deepseq = self.deepseq_1_1_0_2;
      monadPar = self.monadPar_0_1_0_3;
      # deviating from Haskell platform here, to make some packages (notably statistics) compile
      jailbreakCabal = self.jailbreakCabal.override { Cabal = self.disableTest self.Cabal_1_14_0; };
      bmp = self.bmp_1_2_2_1;
      binary = self.binary_0_6_0_0;
      cabalInstall_1_16_0_2 = self.cabalInstall_1_16_0_2.override {
        Cabal = self.Cabal_1_16_0_3;
        zlib = self.zlib_0_5_3_3;
        mtl = self.mtl_2_1_2;
        HTTP = self.HTTP_4000_1_1.override { mtl = self.mtl_2_1_2; };
      };
    };

  # Abstraction for Haskell packages collections
  packagesFun = makeOverridable
   ({ ghcPath
    , ghcBinary ? ghc6101Binary
    , prefFun
    , extraPrefs ? (x : {})
    , profExplicit ? false, profDefault ? false
    , modifyPrio ? lowPrio
    , extraArgs ? {}
    } :
      import ./haskell-packages.nix {
        inherit pkgs newScope modifyPrio;
        prefFun = self : super : self // prefFun super // extraPrefs super;
        # prefFun = self : super : self;
        enableLibraryProfiling =
          if profExplicit then profDefault
                          else config.cabal.libraryProfiling or profDefault;
        ghc = callPackage ghcPath ({ ghc = ghcBinary; } // extraArgs);
      });

  defaultVersionPrioFun =
    profDefault :
    if config.cabal.libraryProfiling or false == profDefault
      then (x : x)
      else lowPrio;

  packages = args : let r = packagesFun args;
                    in  r // { lowPrio     = r.override { modifyPrio   = lowPrio; };
                               highPrio    = r.override { modifyPrio   = x : x; };
                               noProfiling = r.override { profDefault  = false;
                                                          profExplicit = true;
                                                          modifyPrio   = defaultVersionPrioFun false; };
                               profiling   = r.override { profDefault  = true;
                                                          profExplicit = true;
                                                          modifyPrio   = defaultVersionPrioFun true; };
                             };

  # Binary versions of GHC
  #
  # GHC binaries are around for bootstrapping purposes

  # If we'd want to reactivate the 6.6 and 6.8 series of ghc, we'd
  # need to reenable an old binary such as this.
  /*
  ghc642Binary = lowPrio (import ../development/compilers/ghc/6.4.2-binary.nix {
    inherit fetchurl stdenv ncurses gmp;
    readline = if stdenv.system == "i686-linux" then readline4 else readline5;
    perl = perl58;
  });
  */

  ghc6101Binary = lowPrio (callPackage ../development/compilers/ghc/6.10.1-binary.nix {
    gmp = pkgs.gmp4;
  });

  ghc6102Binary = lowPrio (callPackage ../development/compilers/ghc/6.10.2-binary.nix {
    gmp = pkgs.gmp4;
  });

  ghc6121Binary = lowPrio (callPackage ../development/compilers/ghc/6.12.1-binary.nix {
    gmp = pkgs.gmp4;
  });

  ghc704Binary = lowPrio (callPackage ../development/compilers/ghc/7.0.4-binary.nix {
    gmp = pkgs.gmp4;
  });

  ghc742Binary = lowPrio (callPackage ../development/compilers/ghc/7.4.2-binary.nix {
    gmp = pkgs.gmp4;
  });

  ghc6101BinaryDarwin = if stdenv.isDarwin then ghc704Binary else ghc6101Binary;
  ghc6121BinaryDarwin = if stdenv.isDarwin then ghc704Binary else ghc6121Binary;

  # Compiler configurations
  #
  # Here, we associate compiler versions with bootstrap compiler versions and
  # preference functions.

  packages_ghc6104 =
    packages { ghcPath = ../development/compilers/ghc/6.10.4.nix;
               prefFun = ghc6104Prefs;
             };

  packages_ghc6121 =
    packages { ghcPath =  ../development/compilers/ghc/6.12.1.nix;
               prefFun = ghc6121Prefs;
             };

  packages_ghc6122 =
    packages { ghcPath = ../development/compilers/ghc/6.12.2.nix;
               prefFun = ghc6122Prefs;
             };

  packages_ghc6123 =
    packages { ghcPath = ../development/compilers/ghc/6.12.3.nix;
               prefFun = ghc6123Prefs;
             };

  # Will never make it into a platform release, severe bugs; leave at lowPrio.
  packages_ghc701 =
    packages { ghcPath = ../development/compilers/ghc/7.0.1.nix;
               prefFun = ghc701Prefs;
             };

  packages_ghc702 =
    packages { ghcPath = ../development/compilers/ghc/7.0.2.nix;
               prefFun = ghc702Prefs;
             };

  packages_ghc703 =
    packages { ghcPath = ../development/compilers/ghc/7.0.3.nix;
               prefFun = ghc703Prefs;
             };

  # The following items are a bit convoluted, but they serve the
  # following purpose:
  #   - for the default version of GHC, both profiling and
  #     non-profiling versions should be built by Hydra --
  #     therefore, the _no_profiling and _profiling calls;
  #   - however, if a user just upgrades a profile, then the
  #     cabal/libraryProfiling setting should be respected; i.e.,
  #     the versions not matching the profiling config setting
  #     should have low priority -- therefore, the use of
  #     defaultVersionPrioFun;
  #   - it should be possible to select library versions that
  #     respect the config setting using the standard
  #     packages_ghc704 path -- therefore, the additional
  #     call in packages_ghc704, without recurseIntoAttrs,
  #     so that Hydra doesn't build these.

  packages_ghc704 =
    packages { ghcPath = ../development/compilers/ghc/7.0.4.nix;
               ghcBinary = ghc6101BinaryDarwin;
               prefFun = ghc704Prefs;
             };

  packages_ghc721 =
    packages { ghcPath = ../development/compilers/ghc/7.2.1.nix;
               ghcBinary = ghc6121BinaryDarwin;
               prefFun = ghc721Prefs;
             };

  packages_ghc722 =
    packages { ghcPath = ../development/compilers/ghc/7.2.2.nix;
               ghcBinary = ghc6121BinaryDarwin;
               prefFun = ghc722Prefs;
             };

  packages_ghc741 =
    packages { ghcPath = ../development/compilers/ghc/7.4.1.nix;
               ghcBinary = ghc6121BinaryDarwin;
               prefFun = ghc741Prefs;
             };

  packages_ghc742 =
    packages { ghcPath = ../development/compilers/ghc/7.4.2.nix;
               ghcBinary = ghc6121BinaryDarwin;
               prefFun = ghc742Prefs;
             };

  packages_ghc761 =
    packages { ghcPath = ../development/compilers/ghc/7.6.1.nix;
               ghcBinary = ghc704Binary;
               prefFun = ghc763Prefs;
             };

  packages_ghc762 =
    packages { ghcPath = ../development/compilers/ghc/7.6.2.nix;
               ghcBinary = ghc704Binary;
               prefFun = ghc763Prefs;
             };

  packages_ghc763 =
    packages { ghcPath = ../development/compilers/ghc/7.6.3.nix;
               ghcBinary = ghc704Binary;
               prefFun = ghc763Prefs;
             };

  # Reasonably current HEAD snapshot. Should *always* be lowPrio.
  packages_ghcHEAD =
    packages { ghcPath = ../development/compilers/ghc/head.nix;
               ghcBinary = ghc742Binary;
               prefFun = ghcHEADPrefs;
               extraArgs = {
                 happy = pkgs.haskellPackages.happy_1_19_2;
                 alex = pkgs.haskellPackages.alex_3_1_3;
               };
             };

}
