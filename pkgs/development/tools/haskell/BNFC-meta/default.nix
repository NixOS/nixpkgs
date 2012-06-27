{ cabal, alexMeta, happyMeta, haskellSrcMeta, syb }:

cabal.mkDerivation (self: {
  pname = "BNFC-meta";
  version = "0.3.0.3";
  sha256 = "06k8jnb4gw96gc0ffmczbywn4q2n87zwqa0pl0ada3ldvwaagv4l";
  buildDepends = [ alexMeta happyMeta haskellSrcMeta syb ];
  noHaddock = true;
  meta = {
    description = "Deriving Quasi-Quoters from BNF Grammars";
    license = self.stdenv.lib.licenses.gpl2;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
