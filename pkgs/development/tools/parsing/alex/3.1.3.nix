{ cabal, happy, perl, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "alex";
  version = "3.1.3";
  sha256 = "14hajxpqb6va5mclp2k682bgw9sbmd372vw41kq5aq815bkschcd";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ QuickCheck ];
  buildTools = [ happy perl ];
  meta = {
    homepage = "http://www.haskell.org/alex/";
    description = "Alex is a tool for generating lexical analysers in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
