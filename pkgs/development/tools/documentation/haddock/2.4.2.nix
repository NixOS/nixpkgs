{ cabal, alex, Cabal, filepath, ghcPaths, happy }:

cabal.mkDerivation (self: {
  pname = "haddock";
  version = "2.4.2";
  sha256 = "dbf0a7d0103a3ce6a91b2a3b96148c1b9c13ea7f8bd74260c21fe98df7839547";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ Cabal filepath ghcPaths ];
  buildTools = [ alex happy ];
  meta = {
    homepage = "http://www.haskell.org/haddock/";
    description = "A documentation-generation tool for Haskell libraries";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
