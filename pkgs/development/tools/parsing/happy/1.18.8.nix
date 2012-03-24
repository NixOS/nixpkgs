{ cabal, mtl, perl }:

cabal.mkDerivation (self: {
  pname = "happy";
  version = "1.18.8";
  sha256 = "1mqdawxszmdk71fbl8ljxz7jyhai00sflaw0gahp039n44mrspam";
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
