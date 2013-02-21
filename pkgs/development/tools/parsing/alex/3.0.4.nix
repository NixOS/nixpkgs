{ cabal, perl, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "alex";
  version = "3.0.4";
  sha256 = "0fgh7ziwxyb140wghh7dpndh41sixcssnba0q942cvkg77m6ah6d";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ QuickCheck ];
  buildTools = [ perl ];
  meta = {
    homepage = "http://www.haskell.org/alex/";
    description = "Alex is a tool for generating lexical analysers in Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
