{ cabal, perl }:

cabal.mkDerivation (self: {
  pname = "alex";
  version = "2.3.2";
  sha256 = "6715a4c27b15a74d8f31cbb6a7d654b9cb6766d74980c75b65dee7c627049f43";
  isLibrary = false;
  isExecutable = true;
  buildTools = [ perl ];
  meta = {
    homepage = "http://www.haskell.org/alex/";
    description = "Alex is a tool for generating lexical analysers in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
