{ cabal, bytestringLexing, cairo, Chart, colour, dataAccessor
, dataAccessorTemplate, regexTdfa, strptime, time, transformers
, vcsRevision
}:

cabal.mkDerivation (self: {
  pname = "timeplot";
  version = "1.0.20";
  sha256 = "0zlpqfd1l1ss9jjjb967a7jnn1h560ygv8zfiikcx6iagsjmysh2";
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
