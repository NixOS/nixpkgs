{ cabal, Cabal, haskellSrcMeta, mtl }:

cabal.mkDerivation (self: {
  pname = "happy-meta";
  version = "0.2.0.3";
  sha256 = "0bvm4rbmd48vfpyjjfq476466s9hf7x3y0bgzdfkacm89xx080g9";
  buildDepends = [ Cabal haskellSrcMeta mtl ];
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
