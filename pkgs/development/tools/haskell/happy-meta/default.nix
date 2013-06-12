{ cabal, haskellSrcMeta, mtl }:

cabal.mkDerivation (self: {
  pname = "happy-meta";
  version = "0.2.0.5";
  sha256 = "103hi87azqv11l8lq1rv0v9v88sl227g31snvkn8db6b4cfrwrxk";
  buildDepends = [ haskellSrcMeta mtl ];
  meta = {
    description = "Quasi-quoter for Happy parsers";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
