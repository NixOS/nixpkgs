{ cabal, alexMeta, happyMeta, haskellSrcMeta, syb }:

cabal.mkDerivation (self: {
  pname = "BNFC-meta";
  version = "0.3.0.1";
  sha256 = "1qp6aanryrmmip45wgiaf62p842lgc1yqdr8qqn3ljmszxw591ak";
  buildDepends = [ alexMeta happyMeta haskellSrcMeta syb ];
  noHaddock = true;
  meta = {
    description = "Deriving Quasi-Quoters from BNF Grammars";
    license = self.stdenv.lib.licenses.gpl2;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
