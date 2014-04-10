{ cabal, alex, Cabal, deepseq, filepath, ghcPaths, happy, hspec
, QuickCheck, xhtml
}:

cabal.mkDerivation (self: {
  pname = "haddock";
  version = "2.14.1";
  sha256 = "1mxkphzdfd5c8dklfl09ajqwhw8ibvzl0cqrfr2j8rn0j03w46x6";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ Cabal deepseq filepath ghcPaths xhtml ];
  testDepends = [ Cabal deepseq filepath hspec QuickCheck ];
  buildTools = [ alex happy ];
  doCheck = false;
  meta = {
    homepage = "http://www.haskell.org/haddock/";
    description = "A documentation-generation tool for Haskell libraries";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
