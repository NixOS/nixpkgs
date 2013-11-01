{ cabal, perl, QuickCheck }:

cabal.mkDerivation (self: {
  pname = "alex";
  version = "3.1.0";
  sha256 = "1d2kdn4g3zyc3ijiscbqayzg1apy0iih603dv90pr9w2f36djrkh";
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
