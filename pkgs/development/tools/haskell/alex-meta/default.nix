{ cabal, haskellSrcMeta, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "alex-meta";
  version = "0.3.0.3";
  sha256 = "08w7z2iq2s557vi9kp2x8qp1lwvh49skffbjm8kxrf2bn2il5q48";
  buildDepends = [ haskellSrcMeta QuickCheck ];
  noHaddock = true;
  meta = {
    description = "Quasi-quoter for Alex lexers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
