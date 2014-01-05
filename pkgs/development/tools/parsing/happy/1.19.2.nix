{ cabal, mtl, perl }:

cabal.mkDerivation (self: {
  pname = "happy";
  version = "1.19.2";
  sha256 = "1m74dz83fs7gbcr040nhfx1xw3smjk24g5cp6a0wxvrmlh12yc66";
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
