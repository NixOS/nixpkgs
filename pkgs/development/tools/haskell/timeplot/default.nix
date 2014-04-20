{ cabal, bytestringLexing, cairo, Chart, ChartCairo, colour
, dataDefault, lens, regexTdfa, strptime, time, transformers
, vcsRevision
}:

cabal.mkDerivation (self: {
  pname = "timeplot";
  version = "1.0.24";
  sha256 = "1k6xinnnc0723mbf0yvqn6qipjr3hcvy2qjv38sy7f5h0gp8lfhc";
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
