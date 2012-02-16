{ cabal, haskellSrcMeta }:

cabal.mkDerivation (self: {
  pname = "alex-meta";
  version = "0.2.0.2";
  sha256 = "1v47p1nrx2nb92aasq7ml6i0sy1nfyybgm9n4r1sw1g86dg1y8z1";
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
