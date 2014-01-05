{ cabal, bytestringLexing, cairo, Chart, ChartCairo, colour
, dataDefault, lens, regexTdfa, strptime, time, transformers
, vcsRevision
}:

cabal.mkDerivation (self: {
  pname = "timeplot";
  version = "1.0.23";
  sha256 = "0z87yzqv1bjclvyslzpclhrbfm4vcyz0q32jr4kbnfwjk3s8zyi2";
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
