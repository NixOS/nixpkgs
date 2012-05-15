{ cabal, perl, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "alex";
  version = "3.0.2";
  sha256 = "0r1i10i9svnd0ayd229d8hgndgc6q8ghabw6zzghwviw5hs36zlr";
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
