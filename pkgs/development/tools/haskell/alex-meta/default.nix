{ cabal, haskellSrcMeta, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "alex-meta";
  version = "0.3.0.4";
  sha256 = "0d0ii1djigydj2papcilkr8mazp70vg6hy179h28j9i1bshp3anp";
  buildDepends = [ haskellSrcMeta QuickCheck ];
  noHaddock = true;
  meta = {
    description = "Quasi-quoter for Alex lexers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
