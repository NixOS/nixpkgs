{ cabal, mtl, perl }:

cabal.mkDerivation (self: {
  pname = "happy";
  version = "1.19.1";
  sha256 = "0vhyv8pgj3cc31xx1vbdlhc01sfpl6xpzya79bvssnkian2n6yy2";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ mtl ];
  buildTools = [ perl ];
  meta = {
    homepage = "http://www.haskell.org/happy/";
    description = "Happy is a parser generator for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [ self.stdenv.lib.maintainers.andres ];
  };
})
