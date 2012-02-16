{ cabal, alexMeta, happyMeta, haskellSrcMeta }:

cabal.mkDerivation (self: {
  pname = "BNFC-meta";
  version = "0.2.2";
  sha256 = "07jfc0dcrcckibbw0xca1h7x3lnc9jfylfkcs23f0hyg31irf8dx";
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
