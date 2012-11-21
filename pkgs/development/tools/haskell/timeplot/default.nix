{ cabal, bytestringLexing, cairo, Chart, colour, dataAccessor
, dataAccessorTemplate, regexTdfa, strptime, time, transformers
, vcsRevision
}:

cabal.mkDerivation (self: {
  pname = "timeplot";
  version = "1.0.18";
  sha256 = "1q4kzzqmr7bx97wfaasrkzii6b9zpxcxggshpsjv02bwb1hazxmc";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    bytestringLexing cairo Chart colour dataAccessor
    dataAccessorTemplate regexTdfa strptime time transformers
    vcsRevision
  ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/Timeplot";
    description = "A tool for visualizing time series from log files";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
