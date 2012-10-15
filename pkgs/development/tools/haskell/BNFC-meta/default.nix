{ cabal, alexMeta, happyMeta, haskellSrcMeta, syb }:

cabal.mkDerivation (self: {
  pname = "BNFC-meta";
  version = "0.4";
  sha256 = "0qmkc2h4fqryvq763k6skx6c24h9njh4bsdspfbyq1nzxxb9mvy0";
  buildDepends = [ alexMeta happyMeta haskellSrcMeta syb ];
  noHaddock = true;
  meta = {
    description = "Deriving Parsers and Quasi-Quoters from BNF Grammars";
    license = self.stdenv.lib.licenses.gpl2;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
