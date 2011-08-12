{ cabal, alexMeta, happyMeta, haskellSrcMeta }:

cabal.mkDerivation (self: {
  pname = "BNFC-meta";
  version = "0.2.1";
  sha256 = "0c58m1xkaylgp9f3r71nfgqb30fpidldz46dbwalhkb7fm0k4gmm";
  buildDepends = [ alexMeta happyMeta haskellSrcMeta ];
  meta = {
    description = "Deriving Quasi-Quoters from BNF Grammars";
    license = self.stdenv.lib.licenses.gpl2;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
