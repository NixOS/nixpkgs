{ cabal, haskellSrcMeta }:

cabal.mkDerivation (self: {
  pname = "alex-meta";
  version = "0.2.0.1";
  sha256 = "1b508pg4a9f0ln9k91j5dj0mja3faxasz5k6qyxqz3zqnlysm2gj";
  buildDepends = [ haskellSrcMeta ];
  meta = {
    description = "Quasi-quoter for Alex lexers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
