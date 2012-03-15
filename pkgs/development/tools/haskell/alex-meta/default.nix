{ cabal, haskellSrcMeta, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "alex-meta";
  version = "0.3.0.2";
  sha256 = "0kbscnax236qhr18ix9rnfl70z5rgl9zysx5mzd2vrp7h2dymigg";
  buildDepends = [ haskellSrcMeta QuickCheck ];
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
