{ cabal, Cabal, mtl, perl }:

cabal.mkDerivation (self: {
  pname = "happy";
  version = "1.18.9";
  sha256 = "12k1rg7dqa02az9d1zasdnp51zs4h30kpi5lyqsw3jxfp09cad3x";
  isLibrary = false;
  isExecutable = true;
  buildDepends = [ Cabal mtl ];
  buildTools = [ perl ];
  meta = {
    homepage = "http://www.haskell.org/happy/";
    description = "Happy is a parser generator for Haskell";
    license = self.stdenv.lib.licenses.bsd3;
    platforms = self.ghc.meta.platforms;
    maintainers = [
      self.stdenv.lib.maintainers.andres
      self.stdenv.lib.maintainers.simons
    ];
  };
})
