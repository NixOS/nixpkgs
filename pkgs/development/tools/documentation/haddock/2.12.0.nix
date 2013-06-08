{ cabal, alex, Cabal, deepseq, filepath, ghcPaths, happy, xhtml }:

cabal.mkDerivation (self: {
  pname = "haddock";
  version = "2.12.0";
  sha256 = "00kdmpa6vhn6x790641ln40v3pn7aj4ws6pq854n1iyg5ly3ridn";
  isLibrary = true;
  isExecutable = true;
  buildDepends = [ Cabal deepseq filepath ghcPaths xhtml ];
  testDepends = [ Cabal filepath ];
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
