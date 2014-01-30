{ cabal, mtl, perl }:

cabal.mkDerivation (self: {
  pname = "happy";
  version = "1.19.3";
  sha256 = "1q3hipgcwvrf333wlyqmg4mgf24gwiagddlfyr9zgi4k42p2373x";
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
