{ cabal, bytestringLexing, cairo, Chart, colour, dataAccessor
, dataAccessorTemplate, regexTdfa, strptime, time, transformers
, vcsRevision
}:

cabal.mkDerivation (self: {
  pname = "timeplot";
  version = "1.0.11";
  sha256 = "08lgs96wi0issnjwb6w41v3z1bbb6g08hrlbkw7h60rjqkg48svs";
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
