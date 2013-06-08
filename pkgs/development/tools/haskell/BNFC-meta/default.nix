{ cabal, alexMeta, happyMeta, haskellSrcMeta, syb }:

cabal.mkDerivation (self: {
  pname = "BNFC-meta";
  version = "0.4.0.1";
  sha256 = "0x31a25njbgd3r8shh7rrqa9qq66iqjhh82k538p9bd2hblg30ka";
  buildDepends = [ alexMeta happyMeta haskellSrcMeta syb ];
  meta = {
    description = "Deriving Parsers and Quasi-Quoters from BNF Grammars";
    license = self.stdenv.lib.licenses.gpl2;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
