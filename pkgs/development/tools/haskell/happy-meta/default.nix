{ cabal, haskellSrcMeta, mtl }:

cabal.mkDerivation (self: {
  pname = "happy-meta";
  version = "0.2.0.4";
  sha256 = "1s1inv2l2hwdlvypn6wpiadmi5y5mpcjawiqjb1hv0d8y43dpz54";
  buildDepends = [ haskellSrcMeta mtl ];
  meta = {
    description = "Quasi-quoter for Happy parsers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
