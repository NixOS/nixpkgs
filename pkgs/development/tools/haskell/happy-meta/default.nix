{ cabal, haskellSrcMeta, mtl }:

cabal.mkDerivation (self: {
  pname = "happy-meta";
  version = "0.2.0.2";
  sha256 = "1r9i01bnw0dz10balhpgiwcls5jwv5p09jafi8jl6hy0jwx7xydp";
  buildDepends = [ haskellSrcMeta mtl ];
  meta = {
    description = "Quasi-quoter for Happy parsers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
