{ cabal, bytestringLexing, cairo, Chart, ChartCairo, colour
, dataDefault, lens, regexTdfa, strptime, time, transformers
, vcsRevision
}:

cabal.mkDerivation (self: {
  pname = "timeplot";
  version = "1.0.22";
  sha256 = "1dp1prcx3d6a0fr3xrdj6flp27sy7qbng5bbdjgjbb7rq8497if9";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [
    bytestringLexing cairo Chart ChartCairo colour dataDefault lens
    regexTdfa strptime time transformers vcsRevision
  ];
  meta = {
    homepage = "http://haskell.org/haskellwiki/Timeplot";
    description = "A tool for visualizing time series from log files";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
  };
})
