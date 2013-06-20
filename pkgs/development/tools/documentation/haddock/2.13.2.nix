{ cabal, alex, Cabal, deepseq, filepath, ghcPaths, happy, xhtml }:

cabal.mkDerivation (self: {
  pname = "haddock";
  version = "2.13.2";
  sha256 = "1qwj13ks3fzar14s587svv1pdiwk80m7x5pzn74v3jrqkn0xbrr5";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ Cabal deepseq filepath ghcPaths xhtml ];
  testDepends = [ Cabal deepseq filepath ];
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
