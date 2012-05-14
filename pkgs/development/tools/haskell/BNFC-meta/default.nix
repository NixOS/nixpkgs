{ cabal, alexMeta, happyMeta, haskellSrcMeta, syb }:

cabal.mkDerivation (self: {
  pname = "BNFC-meta";
  version = "0.3.0.2";
  sha256 = "0x4x3lpqwjid8rdy6v2wlfbxjvxlg24wjj9fb2niwaqw8b3lyza4";
  buildDepends = [ alexMeta happyMeta haskellSrcMeta syb ];
  noHaddock = true;
  meta = {
    description = "Deriving Quasi-Quoters from BNF Grammars";
    license = self.stdenv.lib.licenses.gpl2;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
