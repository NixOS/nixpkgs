{ cabal, alexMeta, happyMeta, haskellSrcMeta, syb }:

cabal.mkDerivation (self: {
  pname = "BNFC-meta";
  version = "0.3";
  sha256 = "17vmszgq9cyayqlykjbwzvm8mim641vhpzcrdr3l6zb84hr29xgs";
  buildDepends = [ alexMeta happyMeta haskellSrcMeta syb ];
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
