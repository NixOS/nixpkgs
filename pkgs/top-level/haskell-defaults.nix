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
    cabalInstall_1_20_0_4 = super.cabalInstall_1_20_0_4.override { Cabal = null; };
    mtl = self.mtl_2_2_1;
    transformersCompat = super.transformersCompat_0_3_3;
  };

  ghc783Prefs = self : super : ghcHEADPrefs self super // {
    cabalInstall_1_20_0_4 = super.cabalInstall_1_20_0_4.override { Cabal = self.Cabal_1_20_0_2; };
    codex = super.codex.override { hackageDb = super.hackageDb.override { Cabal = self.Cabal_1_20_0_2; }; };
    MonadRandom = self.MonadRandom_0_2_0_1; # newer versions require transformers >= 0.4.x
    mtl = self.mtl_2_1_3_1;
  };

  ghc763Prefs = self : super : ghc783Prefs self super // {
    aeson = self.aeson_0_7_0_4;
    ariadne = super.ariadne.override {
      haskellNames = self.haskellNames.override {
        haskellPackages = self.haskellPackages.override { Cabal = self.Cabal_1_18_1_3; };
      };
    };
    attoparsec = self.attoparsec_0_11_3_1;
    binaryConduit = super.binaryConduit.override { binary = self.binary_0_7_2_2; };
    bson = super.bson.override { dataBinaryIeee754 = self.dataBinaryIeee754.override { binary = self.binary_0_7_2_2; }; };
    cabal2nix = super.cabal2nix.override { hackageDb = super.hackageDb.override { Cabal = self.Cabal_1_18_1_3; }; };
    cabalInstall_1_16_0_2 = super.cabalInstall_1_16_0_2.override {
      HTTP = self.HTTP.override { network = self.network_2_5_0_0; };
      network = self.network_2_5_0_0;
    };
    criterion = super.criterion.override {
      statistics = self.statistics.override {
        vectorBinaryInstances = self.vectorBinaryInstances.override { binary = self.binary_0_7_2_2; };
      };
    };
    entropy = super.entropy.override { cabal = self.cabal.override { Cabal = self.Cabal_1_18_1_3; }; };
    gloss = null;                       # requires base >= 4.7
    modularArithmetic = null;           # requires base >= 4.7
    pipesBinary = super.pipesBinary.override { binary = self.binary_0_7_2_2; };
    rank1dynamic = super.rank1dynamic.override { binary = self.binary_0_7_2_2; };
    distributedStatic = super.distributedStatic.override { binary = self.binary_0_7_2_2; };
    networkTransport = super.networkTransport.override { binary = self.binary_0_7_2_2; };
    distributedProcess = super.distributedProcess.override { binary = self.binary_0_7_2_2; };
    scientific = self.scientific_0_2_0_2;
    singletons = null;                  # requires base >= 4.7
    transformers = self.transformers_0_3_0_0; # core packagen in ghc > 7.6.x
    zipArchive = super.zipArchive_0_2_2_1;    # works without binary 0.7.x
  };

  ghc742Prefs = self : super : ghc763Prefs self super // {
    aeson = self.aeson_0_7_0_4.override { blazeBuilder = self.blazeBuilder; };
    extensibleExceptions = null;        # core package in ghc <= 7.4.x
    hackageDb = super.hackageDb.override { Cabal = self.Cabal_1_16_0_3; };
    haskeline = super.haskeline.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    primitive = self.primitive_0_5_3_0; # later versions don't compile
    random = self.random_1_0_1_1;       # requires base >= 4.6.x
  };

  ghc722Prefs = self : super : ghc742Prefs self super // {
    caseInsensitive = self.caseInsensitive_1_0_0_1;
    deepseq = self.deepseq_1_3_0_2;
    DrIFT = null;                       # doesn't compile with old GHC versions
    syb = self.syb_0_4_0;
  };

  ghc704Prefs = self : super : ghc722Prefs self super // {
    binary = self.binary_0_7_2_2;       # core package in ghc >= 7.2.2
    caseInsensitive = super.caseInsensitive; # undo the override from ghc 7.2.2
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
    logict = super.logict.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    monadPar = self.monadPar_0_1_0_3;
    nats = null;                        # none of our versions compile
    networkUri = super.networkUri.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    parallel = self.parallel_3_2_0_3;
    primitive = self.primitive_0_5_0_1;
    reflection = super.reflection.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    scientific = null;                  # none of our versions compile
    split = self.split_0_1_4_3;
    stm = self.stm_2_4_2;
    syb = null;                         # core package in ghc < 7
    tagged = super.tagged.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    temporary = null;                   # none of our versions compile
    vector = super.vector_0_10_9_3;
    vectorAlgorithms = super.vectorAlgorithms.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
  };

  ghc6104Prefs = self : super : ghc6123Prefs self super // {
    alex = self.alex_2_3_5.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    async = null;                       # none of our versions compile
    attoparsec = null;                  # none of our versions compile
    binary = super.binary_0_7_2_2.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    cabalInstall_1_16_0_2 = super.cabalInstall_1_16_0_2;
    caseInsensitive = super.caseInsensitive.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    GLUT = self.GLUT_2_2_2_1;
    happy = super.happy.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    hashable = super.hashable.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    hashtables = super.hashtables.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    hsyslog = super.hsyslog.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    HTTP = super.HTTP.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    HUnit = super.HUnit.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    network = super.network_2_2_1_7.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    OpenGLRaw = self.OpenGLRaw_1_3_0_0;
    OpenGL = self.OpenGL_2_6_0_1;
    parsec = super.parsec.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    QuickCheck = super.QuickCheck.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    stm = self.stm_2_4_2.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    systemFilepath = super.systemFilepath.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    systemFileio = super.systemFileio.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    tar = super.tar.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    text = self.text_0_11_2_3.override { cabal = self.cabal.override { Cabal = self.Cabal_1_16_0_3; }; };
    tfRandom = null;                    # does not compile
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

  ghc783Binary = lowPrio (callPackage ../development/compilers/ghc/7.8.3-binary.nix {});

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
                 happy = pkgs.haskellPackages.happy;
                 alex = pkgs.haskellPackages.alex;
               };
             };

  packages_ghc783 =
    packages { ghcPath = ../development/compilers/ghc/7.8.3.nix;
               ghcBinary = if stdenv.isDarwin then ghc783Binary else ghc742Binary;
               prefFun = ghc783Prefs;
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
