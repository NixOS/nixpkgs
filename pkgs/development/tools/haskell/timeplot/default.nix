{ cabal, bytestringLexing, cairo, Chart, colour, dataAccessor
, dataAccessorTemplate, regexTdfa, strptime, time, transformers
, vcsRevision
}:

cabal.mkDerivation (self: {
  pname = "timeplot";
  version = "1.0.21";
  sha256 = "0x9f95w235yijp98xx9nry0ibsxr0iyshk6cd89n51xrk1zpk41l";
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
