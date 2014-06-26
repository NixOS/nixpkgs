# Haskell / GHC infrastructure in Nixpkgs
#
# In this file, we
#
#    * define sets of default package versions for each GHC compiler version,
#    * associate GHC versions with bootstrap compiler versions and package defaults.
#
# The actual Haskell packages are composed in haskell-packages.nix. There is
# more documentation in there.

{ makeOverridable, lowPrio, hiPrio, stdenv, pkgs, newScope, config, callPackage } : rec {

  # haskell-packages.nix provides the latest possible version of every package,
  # and this file overrides those version choices per compiler when appropriate.
  # Older compilers inherit the overrides from newer ones.

  ghcHEADPrefs = self : super : super // {
    cabalInstall_1_20_0_2 = super.cabalInstall_1_20_0_2.override { Cabal = null; };
    mtl = self.mtl_2_2_1;
    transformersCompat = super.transformersCompat_0_3_3;
  };

  ghc782Prefs = self : super : ghcHEADPrefs self super // {
    cabalInstall_1_20_0_2 = super.cabalInstall_1_20_0_2.override { Cabal = self.Cabal_1_20_0_1; };
    codex = super.codex.override { hackageDb = super.hackageDb.override { Cabal = self.Cabal_1_20_0_1; }; };
    mtl = self.mtl_2_1_2;
  };

  ghc763Prefs = self : super : ghc782Prefs self super // {
    ariadne = super.ariadne.override {
      haskellNames = self.haskellNames.override {
        haskellPackages = self.haskellPackages.override { Cabal = self.Cabal_1_18_1_3; };
      };
    };
    binaryConduit = super.binaryConduit.override { binary = self.binary_0_7_2_1; };
    bson = super.bson.override { dataBinaryIeee754 = self.dataBinaryIeee754.override { binary = self.binary_0_7_2_1; }; };
    criterion = super.criterion.override {
      statistics = self.statistics.override {
        vectorBinaryInstances = self.vectorBinaryInstances.override { binary = self.binary_0_7_2_1; };
      };
    };
    Elm = super.Elm.override { pandoc = self.pandoc.override { zipArchive = self.zipArchive.override { binary = self.binary_0_7_2_1; }; }; };
    gloss = null;                       # requires base >= 4.7
    haddock = self.haddock_2_13_2;
    modularArithmetic = null;           # requires base >= 4.7
    pipesBinary = super.pipesBinary.override { binary = self.binary_0_7_2_1; };
    rank1dynamic = super.rank1dynamic.override { binary = self.binary_0_7_2_1; };
    distributedStatic = super.distributedStatic.override { binary = self.binary_0_7_2_1; };
    distributedProcess = super.distributedProcess.override { binary = self.binary_0_7_2_1; };
    singletons = null;                  # requires base >= 4.7
    vty_5_1_0 = super.vty_5_1_0.override { cabal = self.cabal.override { Cabal = self.Cabal_1_18_1_3; }; };
    transformers = self.transformers_0_3_0_0; # core packagen in ghc > 7.6.x
    zipArchive = super.zipArchive_0_2_2_1;    # works without binary 0.7.x
  };

  ghc742Prefs = self : super : ghc763Prefs self super // {
    aeson = self.aeson_0_7_0_4.override { blazeBuilder = self.blazeBuilder; };
    attoparsec = self.attoparsec_0_11_3_1;
    extensibleExceptions = null;        # core package in ghc <= 7.4.x
    hackageDb = super.hackageDb.override { Cabal = self.Cabal_1_16_0_3; };
    haddock = self.haddock_2_11_0;
    haskeline = super.haskeline.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    scientific = self.scientific_0_2_0_2;
    shelly = self.shelly_0_15_4_1;
  };

  ghc722Prefs = self : super : ghc742Prefs self super // {
    caseInsensitive = self.caseInsensitive_1_0_0_1;
    deepseq = self.deepseq_1_3_0_2;
    DrIFT = null;                       # doesn't compile with old GHC versions
    haddock = self.haddock_2_9_4;
    syb = self.syb_0_4_0;
  };

  ghc704Prefs = self : super : ghc722Prefs self super // {
    binary = self.binary_0_7_2_1;       # core package in ghc >= 7.2.2
    caseInsensitive = super.caseInsensitive; # undo the override from ghc 7.2.2
    haddock = self.haddock_2_9_2.override { alex = self.alex_2_3_5; };
    HsSyck = self.HsSyck_0_51;
    jailbreakCabal = super.jailbreakCabal.override { Cabal = self.Cabal_1_16_0_3; };
    random = null;                      # core package in ghc <= 7.0.x
  };

  ghc6123Prefs = self : super : ghc704Prefs self super // {
    alex = self.alex_3_1_3;
    async = self.async_2_0_1_4;
    attoparsec = self.attoparsec_0_10_4_0;
    cabalInstall = self.cabalInstall_1_16_0_2;
    cgi = self.cgi_3001_1_7_5;
    deepseq = self.deepseq_1_2_0_1;
    dlist = super.dlist.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    exceptions = null;                  # none of our versions compile
    haddock = self.haddock_2_7_2;
    logict = super.logict.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    monadPar = self.monadPar_0_1_0_3;
    nats = null;                        # none of our versions compile
    parallel = self.parallel_3_2_0_3;
    primitive = self.primitive_0_5_0_1;
    reflection = super.reflection.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    scientific = null;                  # none of our versions compile
    split = self.split_0_1_4_3;
    stm = self.stm_2_4_2;
    syb = null;                         # core package in ghc < 7
    tagged = super.tagged.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    temporary = null;                   # none of our versions compile
    vectorAlgorithms = super.vectorAlgorithms.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
  };

  ghc6104Prefs = self : super : ghc6123Prefs self super // {
    alex = self.alex_2_3_5.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    async = null;                       # none of our versions compile
    attoparsec = null;                  # none of our versions compile
    binary = super.binary_0_7_2_1.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    caseInsensitive = super.caseInsensitive.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    GLUT = self.GLUT_2_2_2_1;
    haddock = self.haddock_2_4_2;
    happy = super.happy.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    hashable = super.hashable.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    hashtables = super.hashtables.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    HTTP = super.HTTP.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    HUnit = super.HUnit.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    network = super.network_2_2_1_7.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    OpenGLRaw = self.OpenGLRaw_1_3_0_0;
    OpenGL = self.OpenGL_2_6_0_1;
    QuickCheck = super.QuickCheck.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    stm = self.stm_2_4_2.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    systemFilepath = super.systemFilepath.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    systemFileio = super.systemFileio.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    tar = super.tar.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    text = self.text_0_11_2_3.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    time = self.time_1_1_2_4.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    zlib = super.zlib.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
 };

  # Abstraction for Haskell packages collections
  packagesFun = makeOverridable
   ({ ghcPath
    , ghcBinary ? ghc6101Binary
    , prefFun
    , extension ? (self : super : {})
    , profExplicit ? false, profDefault ? false
    , modifyPrio ? lowPrio
    , extraArgs ? {}
    } :
    let haskellPackagesClass = import ./haskell-packages.nix {
          inherit pkgs newScope modifyPrio;
          enableLibraryProfiling =
            if profExplicit then profDefault
                            else config.cabal.libraryProfiling or profDefault;
          ghc = callPackage ghcPath ({ ghc = ghcBinary; } // extraArgs);
        };
        haskellPackagesPrefsClass = self : let super = haskellPackagesClass self; in super // prefFun self super;
        haskellPackagesExtensionClass = self : let super = haskellPackagesPrefsClass self; in super // extension self super;
        haskellPackages = haskellPackagesExtensionClass haskellPackages;
    in haskellPackages);

  defaultVersionPrioFun =
    profDefault :
    if config.cabal.libraryProfiling or false == profDefault
      then (x : x)
      else lowPrio;

  packages = args : let r = packagesFun args;
                    in  r // { lowPrio     = r.override { modifyPrio   = lowPrio; };
                               highPrio    = r.override { modifyPrio   = hiPrio; };
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

  packages_ghcHEAD =
    packages { ghcPath = ../development/compilers/ghc/head.nix;
               ghcBinary = pkgs.haskellPackages.ghcPlain;
               prefFun = ghcHEADPrefs;
               extraArgs = {
                 happy = pkgs.haskellPackages.happy_1_19_2;
                 alex = pkgs.haskellPackages.alex_3_1_3;
               };
             };

  packages_ghc782 =
    packages { ghcPath = ../development/compilers/ghc/7.8.2.nix;
               ghcBinary = ghc742Binary;
               prefFun = ghc782Prefs;
             };

  packages_ghc763 =
    packages { ghcPath = ../development/compilers/ghc/7.6.3.nix;
               ghcBinary = ghc704Binary;
               prefFun = ghc763Prefs;
             };

  packages_ghc742 =
    packages { ghcPath = ../development/compilers/ghc/7.4.2.nix;
               ghcBinary = ghc6121BinaryDarwin;
               prefFun = ghc742Prefs;
             };

  packages_ghc722 =
    packages { ghcPath = ../development/compilers/ghc/7.2.2.nix;
               ghcBinary = ghc6121BinaryDarwin;
               prefFun = ghc722Prefs;
             };

  packages_ghc704 =
    packages { ghcPath = ../development/compilers/ghc/7.0.4.nix;
               ghcBinary = ghc6101BinaryDarwin;
               prefFun = ghc704Prefs;
             };

  packages_ghc6123 =
    packages { ghcPath = ../development/compilers/ghc/6.12.3.nix;
               prefFun = ghc6123Prefs;
             };

  packages_ghc6104 =
    packages { ghcPath = ../development/compilers/ghc/6.10.4.nix;
               prefFun = ghc6104Prefs;
             };

}
