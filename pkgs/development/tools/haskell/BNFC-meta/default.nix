{ cabal, alexMeta, happyMeta, haskellSrcMeta, syb }:

cabal.mkDerivation (self: {
  pname = "BNFC-meta";
  version = "0.3.0.5";
  sha256 = "0blssa72r2ff4avbibw9a4p8gxy228f3lb1vc9aqr881v79b2cpp";
  buildDepends = [ alexMeta happyMeta haskellSrcMeta syb ];
  noHaddock = true;
  meta = {
    description = "Deriving Quasi-Quoters from BNF Grammars";
    license = self.stdenv.lib.licenses.gpl2;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
