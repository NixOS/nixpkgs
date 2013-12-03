{ cabal, perl, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "alex";
  version = "3.1.2";
  sha256 = "0v8y6s9gwfk3cda6cpdl0n6vljmjbpnrdi3n93q41x24bhjyn50x";
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
